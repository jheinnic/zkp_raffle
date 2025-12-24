import {
   poseidon2HashWithSeparator,
   poseidon2Hash,
} from "@aztec/foundation/crypto/sync"
import { Hasher } from "@aztec/foundation/trees"
import { Fr } from "@aztec/foundation/fields"

const INTERNAL_NODE_DOMAIN = 1

export class NoirPoseidon2Hasher implements Hasher {
   /**
    * Satisfies the Hasher interface using the functional poseidon2
    */
   hash(lhs: Uint8Array, rhs: Uint8Array): Buffer<ArrayBuffer> {
      const l = Fr.fromBuffer(Buffer.from(lhs))
      const r = Fr.fromBuffer(Buffer.from(rhs))
      const hash: Buffer = poseidon2HashWithSeparator(
         [l, r],
         INTERNAL_NODE_DOMAIN,
      ).toBuffer()

      // Aztec is calling Buffer.from() but not retaining the generic in its return type call
      // signature, so TypeScript believes we still need to make another safe copy, but that
      // has already happened.  Need to use a TypeCast to satisfy the compiler without doing
      // extra unnecessary work at runtime...
      return hash as Buffer<ArrayBuffer>
   }

   hashInputs(inputs: Array<Buffer>): Buffer<ArrayBuffer> {
      console.error("Hasher buffer method called with ", inputs)
      // Aztec is calling Buffer.from() but not retaining the generic in its return type call
      // signature, so TypeScript believes we still need to make another safe copy, but that
      // has already happened.  Need to use a TypeCast to satisfy the compiler without doing
      // extra unnecessary work at runtime...
      return poseidon2Hash(inputs).toBuffer() as Buffer<ArrayBuffer>
   }
}
