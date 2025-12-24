// import { newTree  } from "@aztec/merkle-tree"
// import { Hasher } from "@aztec/foundation/trees"
// import { Bufferable, FromBuffer } from "@aztec/foundation/serialize"
// import type { AztecKVStore } from "@aztec/kv-store";
// import type { TreeBase } from "@aztec/merkle-tree";
import { StandardTree, newTree, Poseidon } from '@aztec/merkle-tree';
import { poseidon2HashWithSeparator } from '@aztec/foundation/crypto/sync';
import { AztecLmdbStore } from '@aztec/kv-store/lmdb';
import { Fr } from '@aztec/foundation/fields';
import leveldown from 'leveldown';

export class NoirPoseidon2Hasher {
  /**
   * Satisfies the Hasher interface using the functional poseidon2
   */
  hash(lhs, rhs) {
    const l = Fr.fromBuffer(Buffer.from(lhs));
    const r = Fr.fromBuffer(Buffer.from(rhs));

    // Calling the functional export directly
    // This usually takes an array of Fr elements
    const hash = poseidon2HashWithSeparator([l, r], 1).toBuffer();
    console.error("L = ", l, "; R = ", r, "; Sep = 1; Hash = ", hash);
    return hash;
  }

  hashInputs(inputs) {
    const fields = inputs.map(i => Fr.fromBuffer(i));
    return poseidon2Hash(fields).toBuffer();
  }
}

async function runMerkleExample() {
    // 1. Setup the Database (Persistent storage for 30M leaves)
    // const db = await openDb('merkle_db', leveldown, true);

    // 30.5M leaves * 64 bytes (node + meta) is roughly 2GB.
    // We set mapSize to 4GB to be safe.
    const mapSizeKb = 4 * 1024;
    const path = './merkle_lmdb';

    // Static open method from your grep findings
    const store = AztecLmdbStore.open(path, mapSizeKb, false);

    // 2. Define Tree Parameters
    // Height 25 can hold ~33 million leaves
    const height = 25;
    const name = 'PrizeTree';

    // 3. Initialize the Tree
    // We use Poseidon2 as the hasher (native to Noir)
    const hasher = new NoirPoseidon2Hasher();
    const tree = await newTree(StandardTree, store, hasher, name, Fr, height);

    // 4. Create a Leaf (e.g., a hashed Grumpkin Public Key)
    // Remember: Noir Fields are 'Fr' in Aztec Foundation
    const leafValue = Fr.random();
    const index = 0n;

    // 5. Update the Tree
    console.error("Updating leaf...");
    await tree.appendLeaves([leafValue]);

    // 6. Get the Root and a Membership Proof
    const root = tree.getRoot();
    const proof = await tree.getSiblingPath(index);

    console.error('New Tree Root:', root.toString("hex"));
    console.error('Proof Sibling Path Length:', proof.toBuffer().length);

    console.error('Zero(0): ', Fr.fromBuffer(tree.getZeroHash(25)));

    return { root, proof };
}

console.error(await runMerkleExample().catch(console.error));
