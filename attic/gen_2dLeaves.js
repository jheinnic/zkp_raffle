import {BinaryMerkleTree} from "binary-merkle-noir";
import {readFileSync} from "fs";

// Create a new tree
const tree = new BinaryMerkleTree(2);

const data = readFileSync("leaves.dat")
const content = data.toString("utf8")
const leaves = content.split("\n")
const lastIndex = leaves.length - 1
leaves.forEach((leaf, idx) => {
    if ( leaf === "" ) {
        return
    }
    const buf = Buffer.from(leaf, "hex")
    tree.insertItem([buf.readBigUint64BE(), buf.readBigUint64BE(8)]);
})
tree.lockTree()
let idx = 0
try{
    while(idx < lastIndex) {
        const proofOdd = tree.generateProof(idx)
        proofOdd["myIndex"] = idx
        console.error(JSON.stringify(proofOdd, replacer))
        console.error(tree.verifyProof(proofOdd))
        idx = idx + 1;
    }
} catch(err) {
    console.error("Failed to prove index " + idx.toString(10) + " (Hex: " + idx.toString(16))
    console.error(err)
}

console.error("Tree items:")
console.error(JSON.stringify(tree, replacer))

function replacer(key, value) {
    // Check if the current value is a BigInt
    if (typeof value === 'bigint') {
        // Convert it to its string representation in hex
        return value.toString(16);
    }
    // For all other types, return the value as is
    return value;
}
