import { bootstrapCeremony, CeremonyContainer } from "./CeremonyContainer.js"
import { runPipelinedScatterGather } from "./MintingCeremony.js"

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

runPipelinedScatterGather(container)
