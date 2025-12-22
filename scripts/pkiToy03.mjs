import { Grumpkin } from '@aztec/foundation/crypto';
import { GrumpkinScalar } from '@aztec/foundation/fields';
import { Point } from '@aztec/foundation/fields';

BN254_MODULUS = BigInt("0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001")
async function performECDH() {
    const grumpkin = new Grumpkin();

    // 1. Setup Alice's Keys
    let alicePrv = GrumpkinScalar.random();
    while (alicePriv.asBigInt >= BN254_MODULUS) {
        alicePrv = GrumpkinScalar.random();
    }
    const alicePub = grumpkin.mul(Grumpkin.generator, alicePrv);

    // 2. Setup Bob's Keys
    let bobPrv = GrumpkinScalar.random();
    while (bobPriv.asBigInt >= BN254_MODULUS) {
        bobPrv = GrumpkinScalar.random();
    }
    const bobPub = grumpkin.mul(Grumpkin.generator, bobPrv);

    // 3. ECDH: Alice computes the shared secret
    // Shared Secret = Alice's Prvate Key * Bob's Public Point
    const sharedSecretAlice = grumpkin.mul(bobPub, alicePrv);
    console.log(sharedSecretAlice);
    console.log(JSON.stringify(sharedSecretAlice));

    // 4. ECDH: Bob computes the shared secret
    // Shared Secret = Bob's Prvate Key * Alice's Public Point
    const sharedSecretBob = grumpkin.mul(alicePub, bobPrv);

    // Verify they match
    console.log('Alice Shared X:', sharedSecretAlice.x.toString());
    console.log('Alice Shared Y:', sharedSecretAlice.y.toString());
    console.log('Bob Shared X:', sharedSecretBob.x.toString());
    console.log('Bob Shared Y:', sharedSecretBob.y.toString());
    console.log('Match:', sharedSecretAlice === sharedSecretBob);
}

console.log("Run One")
await performECDH()
console.log("Run Two")
await performECDH()
console.log("Run Three")
await performECDH()
