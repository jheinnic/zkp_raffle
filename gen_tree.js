import {IndexedMerkleTree} from 'indexed-merkle-noir';

// Create a new tree
const tree = new IndexedMerkleTree();

// Insert an item (key must be bigint > 0, value must be bigint >= 0)
tree.insertItem(10n, 345n);
tree.insertItem(20n, 234n);
const transitionProof = tree.insertItem(30n, 123n);

// Generate proof for a key
const proof = tree.generateProof(20n);
console.log(JSON.stringify(proof, replacer))
// Returns { leafIdx, leaf, root, siblings }

// Generate exclusion proof (proves a key does NOT exist)
const exclusionProof = tree.generateExclusionProof(13n);
// Returns proof for neighboring key that proves 13n doesn't exist

// Verify a proof
const isValid = tree.verifyProof(proof);
const isValidInsert = tree.verifyInsertionProof(transitionProof);
const isValidExclusion = tree.verifyProof(exclusionProof);
// Returns true if proof is valid

console.log(JSON.stringify(tree.items, replacer))
console.log(JSON.stringify(exclusionProof, replacer))
console.log(isValid, isValidInsert, isValidExclusion)

function replacer(key, value) {
    // Check if the current value is a BigInt
    if (typeof value === 'bigint') {
        // Convert it to its string representation in hex
        return value.toString(16);
    }
    // For all other types, return the value as is
    return value;
}
