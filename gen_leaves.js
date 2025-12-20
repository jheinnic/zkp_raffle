import {IndexedMerkleTree} from "indexed-merkle-noir";
import {readFileSync} from "fs";

// Create a new tree
const tree = new IndexedMerkleTree();

const data = readFileSync("leaves.dat")
const content = data.toString("utf8")
const leaves = content.split("\n")
const lastIndex = leaves.length - 1
leaves.forEach((leaf, idx) => {
    if ( leaf === "" ) {
        return
    }
    const buf = Buffer.from(leaf, "hex")
    // Insert items (key must be bigint > 0, value must be bigint >= 0)
    tree.insertItem(BigInt(((2 * idx) + 1) * 5), buf.readBigUint64BE());
    tree.insertItem(BigInt((2 * (idx + 1)) * 4), buf.readBigUint64BE(8));
})
let idx = 0
try{
    while(idx < lastIndex) {
	const oddIdx = BigInt(((2 * idx) + 1) * 5)
	const proofOdd = tree.generateProof(oddIdx)
        proofOdd["myIndex"] = idx
        console.log(JSON.stringify(proofOdd, replacer))
	const evenIdx = BigInt((2 * (idx + 1)) * 4)
        const proofEven = tree.generateProof(evenIdx)
        proofEven["myIndex"] = idx
        console.log(JSON.stringify(proofEven, replacer))
        idx = idx + 1;
    }
} catch(err) {
    console.error("Failed to prove index " + idx.toString(10) + " (Hex: " + idx.toString(16))
    console.error(err)
}

console.log(JSON.stringify(tree.items, replacer))

function replacer(key, value) {
    // Check if the current value is a BigInt
    if (typeof value === 'bigint') {
        // Convert it to its string representation in hex
        return value.toString(16);
    }
    // For all other types, return the value as is
    return value;
}
