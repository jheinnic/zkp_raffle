import { CeremonyContainer } from "./CeremonyContainer.js"

import { Worker } from "node:worker_threads"
import { fileURLToPath } from "node:url"
import path from "node:path"
import { createLogger } from "@aztec/foundation/log"

// 1. Define the message interface for type safety
interface WorkerMessage {
   resultBuffer: Uint8Array
   startIdx: number
}

export async function runPipelinedScatterGather(ctx: CeremonyContainer) {
   const { store, tree, masterSeed, spec }: CeremonyContainer = ctx
   const workerCount = spec.workerCount
   const maxInFlight = spec.maxInFlight
   const mintBatchSize = spec.mintBatchSize
   const totalTickets: number = spec.totalTickets
   const logger = createLogger("MintingCeremony:Leader")

   let nextIndexToIssue = Number(tree.getNumLeaves(false))
   let nextIndexToAppend = nextIndexToIssue
   let inFlightCount = 0
   const pendingBatches = new Map<number, Uint8Array>()
   const activeWorkers = new Set<Worker>()
   const pausedWorkers = new Array<Worker>()
   const terminalWorkers = new Set<Worker>()

   return new Promise((resolve: (value: Buffer) => void) => {
      async function issueWork(worker: Worker): Promise<void> {
         if (nextIndexToIssue < totalTickets) {
            if (inFlightCount < maxInFlight) {
               const startIdx = nextIndexToIssue
               nextIndexToIssue += mintBatchSize
               inFlightCount++
               worker.postMessage({
                  masterSeed,
                  startIdx,
                  count: mintBatchSize,
               })
               logger.info(
                  "Sent task " +
                     (startIdx / mintBatchSize).toString(10) +
                     " to " +
                     worker.threadId.toString(10),
               )
            } else {
               logger.info(
                  "Paused worker " +
                     worker.threadId.toString(10) +
                     " with " +
                     inFlightCount.toString(10) +
                     " results in flight ",
               )
               pausedWorkers.push(worker)
               activeWorkers.delete(worker)
            }
         } else {
            const exitCode = await worker.terminate()
            logger.info(
               "Terminated worker " +
                  worker.threadId.toString(10) +
                  " with exit code " +
                  exitCode.toString(10),
            )
            terminalWorkers.add(worker)
            activeWorkers.delete(worker)
         }
      }

      async function onMessage(
         worker: Worker,
         resultBuffer: Uint8Array,
         startIdx: number,
      ): Promise<void> {
         pendingBatches.set(startIdx, resultBuffer)
         logger.info(
            "Received completion of " +
               (startIdx / mintBatchSize).toString(10) +
               " from " +
               worker.threadId.toString(10),
         )

         // 1. Pipeline: Give the worker more work IMMEDIATELY
         issueWork(worker)

         // 2. Gather: Sequence the results into the tree
         while (pendingBatches.has(nextIndexToAppend)) {
            const rawData: Uint8Array | undefined =
               pendingBatches.get(nextIndexToAppend)
            if (rawData === undefined)
               throw new Error("Received undefined data from worker??")
            pendingBatches.delete(nextIndexToAppend)
            const leaves: Buffer[] = []
            for (let i = 0; i < rawData.length; i += 32) {
               leaves.push(Buffer.from(rawData.subarray(i, i + 32)))
            }
            await tree.appendLeaves(leaves)
            await tree.commit()
            nextIndexToAppend += mintBatchSize
            inFlightCount--
            console.log(
               `[${new Date().toISOString()}] Progress: ${nextIndexToAppend}`,
            )

            while (pausedWorkers.length > 0 && inFlightCount < maxInFlight) {
               const idleWorker = pausedWorkers.pop()
               if (idleWorker === undefined)
                  throw new Error("undefined Worker waiting in queue")
               if (nextIndexToIssue < totalTickets) {
                  activeWorkers.add(idleWorker)
                  issueWork(idleWorker)
               } else {
                  terminalWorkers.add(idleWorker)
                  await idleWorker.terminate()
               }
            }
         }

         // 3. Check for completion
         if (nextIndexToAppend >= totalTickets) resolve(tree.getRoot(false))
      }

      // Start Pool
      const __dirname = path.dirname(fileURLToPath(import.meta.url))
      const workerPath = path.resolve(__dirname, "./keyWorker.js")
      for (let i = 0; i < workerCount; i++) {
         const worker = new Worker(workerPath)
         worker.on(
            "message",
            (m: WorkerMessage): Promise<void> =>
               onMessage(worker, m.resultBuffer, m.startIdx),
         )
         activeWorkers.add(worker)
         issueWork(worker)
      }
   }).then(async (value: Buffer): Promise<Buffer> => {
      console.log("Main job has received a final merkle root of ", value)
      const shutdownPromises: Promise<any>[] = [...activeWorkers].map(
         async (x: Worker) => {
            return await x.terminate().then((exit) => {
               activeWorkers.delete(x)
               terminalWorkers.add(x)
               return exit
            })
         },
      )
      shutdownPromises.push(store.close())
      console.log(await Promise.all(shutdownPromises))
      return value
   })
}
