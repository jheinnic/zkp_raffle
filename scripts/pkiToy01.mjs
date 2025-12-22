import { generateKeyPairSync } from "crypto"
import { bn254, bn254_Fr } from '@noble/curves/bn254.js';

function dskds() {
      const { publicKey } = generateKeyPairSync("ec", {
         namedCurve: "secp256k1", // Options
         publicKeyEncoding: {
            type: "spki",
            format: "der",
         },
         privateKeyEncoding: {
            type: "pkcs8",
            format: "der",
         },
      })
      console.log(JSON.stringify(
	      Buffer.from(publicKey).toString("hex")));
}

function bn254Key() {
      // 1. Setup Keys
      const alicePriv = bn254.utils.randomSecretKey();
      const alicePrivFr = bn254_Fr.fromBytes(alicePriv);
      const alicePubPoint = bn254.G1.Point.BASE.multiply(alicePrivFr)

      const bobPriv = bn254.utils.randomSecretKey();
      const bobPrivFr = bn254_Fr.fromBytes(bobPriv);
      const bobPubPoint = bn254.G1.Point.BASE.multiply(bobPrivFr)
      
      // 2. Derive Shared Secret Point: S = d_A * Q_B
      const sharedPointOne = bobPubPoint.multiply(alicePrivFr);
      const sharedPointTwo = alicePubPoint.multiply(bobPrivFr);

      console.log("Alice Private Key: ", alicePriv);
      console.log("Alice Private Fr: ", alicePrivFr);
      console.log("Bob Public Point: ", bobPubPoint);
      console.log("Shared Point: ", sharedPointOne);
      console.log("Shared Point X: ", sharedPointOne.X);
      console.log("Shared Point Y: ", sharedPointOne.Y);
      console.log("Shared Point: ", sharedPointTwo);
      console.log("Shared Point X: ", sharedPointTwo.X);
      console.log("Shared Point Y: ", sharedPointTwo.Y);
      
      // 3. Extract Coordinates
      const x = sharedPointOne.X;
      const y = sharedPointOne.Y;
      
      //console.log("Shared Point X:", x.toString());
      //console.log("Shared Point Y:", y.toString());
}

dskds();
bn254Key();
