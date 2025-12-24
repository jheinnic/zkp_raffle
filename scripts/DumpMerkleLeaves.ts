import { poseidon2HashWithSeparator } from "@aztec/foundation/crypto/sync"
import { Point, Fr, Fq } from "@aztec/foundation/fields"
import { bootstrapCeremony, CeremonyContainer } from "./CeremonyContainer.js"
import { InterimKeyRing } from "./InterimKeyRing.js"

const envConfig = {
   mapSizeKb: process.env.MAP_SIZE_KB
      ? Number.parseInt(process.env.MAP_SIZE_KB)
      : undefined,
   totalTickets: process.env.TOTAL_TICKETS
      ? Number.parseInt(process.env.TOTAL_TICKETS)
      : undefined,
   mintBatchSize: process.env.MINT_BATCH_SIZE
      ? Number.parseInt(process.env.MINT_BATCH_SIZE)
      : undefined,
   ticketDbPath: process.env.TICKET_DB_PATH,
   treeDepth: process.env.TICKET_TREE_DEPTH
      ? Number.parseInt(process.env.TICKET_TREE_DEPTH)
      : undefined,
   treeName: process.env.TICKET_TREE_NAME,
}
// Remove keys with undefined values so defaults in bootstrapCeremony can kick in
const cleanedConfig = Object.fromEntries(
   Object.entries(envConfig).filter(
      ([_, v]) => v !== undefined && !Number.isNaN(v),
   ),
)

const container = await bootstrapCeremony(cleanedConfig)

await pullSomeProofs(container)

async function pullSomeProofs(context: CeremonyContainer) {
   const { tree } = context
   console.log(tree.getNumLeaves(false))
   console.log(tree.getRoot(false))
   console.log(tree.getDepth())
   const keyRing = new InterimKeyRing(
      Buffer.from(process.env["MASTER_SEED"] ?? "NOTHING"),
      false,
   )

   async function checkIndex(index: number): Promise<void> {
      const bigIndex = BigInt(index)
      const leafValue = tree.getLeafValue(bigIndex, false)
      const siblingPath = tree.getSiblingPath(bigIndex, false)

      await keyRing.deriveKeyPair(index)
      const publicKey = keyRing.currentPublicKey.publicKey
      // const privateKey: Fq = keyRing.currentKeyPair.privateKey
      const publicKeyHash: Fr = poseidon2HashWithSeparator(
         publicKey.toFields(),
         0,
      )
      console.log("For index = ", index)
      console.log("Leaf Value = ", leafValue)
      console.log("Public Key Hash = ", publicKeyHash)
      console.log("Public Key = ", publicKey)
      console.log("Sibling Path = ", siblingPath)
      // console.log("Private Key = ", privateKey)
   }

   checkIndex(1024)
   checkIndex(999424)
   checkIndex(17777777)
   checkIndex(32500000)
   checkIndex(32580800)
   checkIndex(1)
   checkIndex(2)
   checkIndex(3)
   checkIndex(16384)
   checkIndex(4096)
   checkIndex(8191)
   checkIndex(8192)
   checkIndex(8193)
   checkIndex(1592193)
   checkIndex(10592193)
   checkIndex(15992193)
   checkIndex(25992193)
   checkIndex(8492193)
}
