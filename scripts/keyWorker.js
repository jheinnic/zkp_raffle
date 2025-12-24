import { poseidon2HashWithSeparator } from "@aztec/foundation/crypto/sync";
import { Fq } from "@aztec/foundation/fields"
import { parentPort } from "node:worker_threads";
import { InterimKeyRing } from "./InterimKeyRing.js";

let keyRing;

parentPort.on("message", async ({ masterSeed, startIdx, count }) => {
    if (!keyRing) keyRing = new InterimKeyRing(masterSeed);

    // Allocate a raw buffer for the hashes (32 bytes per Fr)
    const resultBuffer = new Uint8Array(count * 32);
    let lastHash
    for (let i = 0; i < count; i++) {
        await keyRing.deriveKeyPair(startIdx + i);
        const pub = keyRing.currentPublicKey.publicKey;
        
        // Compute the leaf hash
        const leaf = poseidon2HashWithSeparator(pub, 0);
        
        // Write directly into the Uint8Array
        resultBuffer.set(leaf.toBuffer(), i * 32);
    }

    // [Transferable] Move the buffer to the main thread. 
    // The worker can no longer access this memory.
    parentPort.postMessage({ resultBuffer, startIdx }, [resultBuffer.buffer]);
});
