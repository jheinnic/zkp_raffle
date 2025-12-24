import { StandardTree, newTree, loadTree } from "@aztec/merkle-tree"
import type { AztecKVStore } from "@aztec/kv-store"
import { AztecLmdbStore } from "@aztec/kv-store/lmdb"
import { FromBuffer } from "@aztec/foundation/serialize"
// import { createLogger } from "@aztec/foundation/log";

import os from "node:os"

import { NoirPoseidon2Hasher } from "./NoirPoseidon2Hasher.js"

export interface CeremonyConfig {
   totalTickets?: number
   mintBatchSize?: number
   workerCount?: number
   maxInFlight?: number
   treeDepth?: number
   mapSizeKb?: number
   treeName?: string
   ticketDbPath?: string
}

// The "Single Source of Truth" constants
const PROD_DEFAULTS = {
   TOTAL_TICKETS: 32_580_000,
   MINT_BATCH_SIZE: 16384,
   TREE_DEPTH: 26, // Hard-coded to match the ZK-circuit
   TREE_NAME: "tickets_v1",
   DB_PATH: "./merkle_lmdb",
   BYTES_PER_NODE: 256, // Conservative estimate for LMDB overhead + Fr size
}

/**
 * Calculates a safe LMDB map size based on the ticket count.
 */
function calculateMapSize(totalTickets: number): number {
   // (Tickets * 2) to account for internal nodes * size per node
   const estimatedBytes = totalTickets * 2 * PROD_DEFAULTS.BYTES_PER_NODE
   const padding = 1.5 // 50% safety buffer
   return Math.ceil((estimatedBytes * padding) / 1024)
}

export interface CeremonyContainer {
   readonly store: AztecKVStore
   readonly tree: StandardTree<Buffer>
   readonly masterSeed: Buffer
   readonly spec: CeremonySpec
}

export interface CeremonySpec {
   readonly mintBatchSize: number
   readonly workerCount: number
   readonly maxInFlight: number
   readonly totalTickets: number
}

class BufferSerializer implements FromBuffer<Buffer> {
   fromBuffer(buffer: Buffer): Buffer<ArrayBufferLike> {
      return buffer
   }
}

export async function bootstrapCeremony(
   overrides: CeremonyConfig = {},
): Promise<CeremonyContainer> {
   const totalTickets = overrides.totalTickets ?? PROD_DEFAULTS.TOTAL_TICKETS
   const treeDepth = overrides.treeDepth ?? PROD_DEFAULTS.TREE_DEPTH
   const treeName = overrides.treeName ?? PROD_DEFAULTS.TREE_NAME
   const ticketDbPath = overrides.ticketDbPath ?? PROD_DEFAULTS.DB_PATH

   // Map size defaults to a calculation based on ticket count if not provided
   const mapSizeKb = overrides.mapSizeKb ?? calculateMapSize(totalTickets)
   const store = AztecLmdbStore.open(ticketDbPath, mapSizeKb, false)
   const hasher = new NoirPoseidon2Hasher()
   const serializer = new BufferSerializer()
   let tree: StandardTree<Buffer>

   try {
      tree = await loadTree<StandardTree, BufferSerializer>(
         StandardTree,
         store,
         hasher,
         treeName,
         serializer,
      )
      console.log(`♻️  Resuming ceremony at index ${tree.getNumLeaves(false)}`)
   } catch (e) {
      console.log(`🌱 Creating new ${treeDepth}-level tree: "${treeName}"`)
      tree = await newTree<StandardTree, BufferSerializer>(
         StandardTree,
         store,
         hasher,
         treeName,
         serializer,
         treeDepth,
      )
      await tree.commit()
   }

   const mintBatchSize =
      overrides.mintBatchSize ?? PROD_DEFAULTS.MINT_BATCH_SIZE
   const workerCount = overrides.workerCount ?? os.cpus().length
   const maxInFlight = overrides.maxInFlight ?? workerCount * 2

   return {
      store,
      tree,
      masterSeed: Buffer.from(process.env.MASTER_SEED || "0".repeat(64), "hex"),
      spec: {
         mintBatchSize,
         workerCount,
         maxInFlight,
         totalTickets,
      },
   }
}
