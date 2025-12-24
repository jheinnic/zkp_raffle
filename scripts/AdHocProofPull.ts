import os from "node:os"
import fs from "node:fs/promises"
import { fileURLToPath } from "node:url"
import { dirname, resolve } from "node:path"
import {
   compile,
   createFileManager,
   ProgramCompilationArtifacts,
} from "@noir-lang/noir_wasm"
import { UltraHonkBackend } from "@aztec/bb.js"
import { Noir } from "@noir-lang/noir_js"
import {
   poseidon2HashWithSeparator,
   poseidon2Hash,
} from "@aztec/foundation/crypto/sync"
import { Point, Fr, Fq } from "@aztec/foundation/fields"
import { Grumpkin } from "@aztec/foundation/crypto"

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
   const compiledCircuit: ProgramCompilationArtifacts = await compile(
      createFileManager(resolve(dirname(fileURLToPath(import.meta.url)), "..")),
   )
   const noir = new Noir(compiledCircuit.program)
   const backend = new UltraHonkBackend(compiledCircuit.program.bytecode, {
      threads: os.cpus().length,
   })
   const g = new Grumpkin()

   const { tree } = context
   console.log(tree.getNumLeaves(false))
   console.log(tree.getRoot(false))
   console.log(tree.getDepth())
   const keyRing = new InterimKeyRing(
      Buffer.from(process.env["MASTER_SEED"] ?? "0".repeat(64), "hex"),
      true,
   )
   const raffle_priv_key: Fq = Fq.random()
   const raffle_pub_key: Point = await g.mul(g.generator(), raffle_priv_key)
   console.log("Raffle private key = ", raffle_priv_key)
   console.log("Raffle public key = ", raffle_pub_key)

   async function checkIndex(index: number): Promise<void> {
      const bigIndex = BigInt(index)
      const leafValue = await tree.getLeafValue(bigIndex, false)
      const siblingPath = await tree.getSiblingPath(bigIndex, false)

      await keyRing.deriveKeyPair(index)
      const publicKey = keyRing.currentPublicKey.publicKey
      const pkFields: Fr[] = publicKey.toFields()
      const privateKey: Fq = keyRing.currentKeyPair.privateKey
      const publicKeyHash: Fr = poseidon2HashWithSeparator(pkFields, 0)
      const publicKeyHash2: Fr = poseidon2Hash([
         0,
         pkFields[0],
         pkFields[1],
         pkFields[2],
      ])
      console.log("For index = ", index)
      console.log("Leaf Value = ", leafValue)
      console.log("Public Key Hash = ", publicKeyHash)
      console.log("Public Key Hash 2 = ", publicKeyHash2)
      console.log("Public Key = ", publicKey)
      console.log("Sibling Path = ", siblingPath)
      console.log("Private Key = ", privateKey)

      const prize_point: Point = await g.mul(raffle_pub_key, privateKey)
      const prize_hash: Fr = poseidon2HashWithSeparator(
         prize_point.toFields(),
         3,
      )
      console.log("Prize point = ", prize_point)
      console.log("Prize hash = ", prize_hash)

      const indexBits: number[] = new Array(26)
      let ii = 0
      let jj: number = index
      while (ii < 26) {
         indexBits[ii] = jj % 2
         jj = jj >> 1
         ii = ii + 1
      }

      const inputs = {
         index: index,
         index_bits: indexBits,
         path: siblingPath.toBufferArray().map((x) => {
            return "0x" + x.toString("hex")
         }),
         prize_ecdhkey_hash: "0x" + prize_hash.toBuffer().toString("hex"),
         prize_ecdhkey_x: "0x" + prize_point.x.toBuffer().toString("hex"),
         prize_ecdhkey_y: "0x" + prize_point.y.toBuffer().toString("hex"),
         raffle_pubkey_x: "0x" + raffle_pub_key.x.toBuffer().toString("hex"),
         raffle_pubkey_y: "0x" + raffle_pub_key.y.toBuffer().toString("hex"),
         ticket_pubkey_hash: "0x" + publicKeyHash.toBuffer().toString("hex"),
         ticket_pubkey_x: "0x" + publicKey.x.toBuffer().toString("hex"),
         ticket_pubkey_y: "0x" + publicKey.y.toBuffer().toString("hex"),
         ticket_priv_key: "0x" + privateKey.toBuffer().toString("hex"),
         tickets_merkle_root: "0x" + tree.getRoot(false).toString("hex"),
      }
      console.log(inputs)
      const { witness } = await noir.execute(inputs)
      const { proof, publicInputs } = await backend.generateProof(witness)
      console.log("Ok? = ", await backend.verifyProof({ proof, publicInputs }))

      // --- Add this block to save Prover.toml ---
      const tomlContent = Object.entries(inputs)
         .map(([key, value]) => {
            if (Array.isArray(value)) {
               // Format arrays: ["0x..", "0x.."]
               const items = value
                  .map((v) => (typeof v === "string" ? `"${v}"` : v))
                  .join(", ")
               return `${key} = [${items}]`
            } else if (typeof value === "string") {
               // Format hex strings: "0x.."
               return `${key} = "${value}"`
            } else {
               // Format numbers (index, etc)
               return `${key} = ${value}`
            }
         })
         .join("\n")

      const outputPath = resolve(
         dirname(fileURLToPath(import.meta.url)),
         `../Prover_${index}.toml`,
      )
      await fs.writeFile(outputPath, tomlContent)
      console.log(`Saved inputs to ${outputPath}`)
   }

   await checkIndex(1024)
   await checkIndex(1023)
   await checkIndex(1025)
   await checkIndex(1022)
   await checkIndex(1021)
   await checkIndex(1026)
   await checkIndex(999424)
   await checkIndex(17777777)
   await checkIndex(32500000)
   await checkIndex(32580800)
   await checkIndex(1)
   await checkIndex(2)
   await checkIndex(3)
   await checkIndex(16384)
   await checkIndex(4096)
   await checkIndex(8191)
   await checkIndex(8192)
   await checkIndex(8193)
   await checkIndex(1592193)
   await checkIndex(10592193)
   await checkIndex(15992193)
   await checkIndex(25992193)
   await checkIndex(8492193)
}
