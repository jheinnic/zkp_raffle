import { Grumpkin } from "@aztec/foundation/crypto"
import { GrumpkinScalar, Point } from "@aztec/foundation/fields"
import crypto from "node:crypto"

const grumpkin: Grumpkin = new Grumpkin()
const GRUMPKIN_G: Point = grumpkin.generator()
const GRUMPKIN_ZERO: GrumpkinScalar = GrumpkinScalar.ZERO

const GRUMPKIN_R: bigint = GrumpkinScalar.MODULUS
const CURVE_SEED: Buffer = Buffer.from("Grumpkin Raffle Seed v1")

function hmacSha512(chainCode: Buffer, data: Buffer): Buffer {
   return crypto.createHmac("sha512", chainCode).update(data).digest()
}
export interface KeyPair {
   privateKey: GrumpkinScalar
   publicKey: Point
}

export interface PublicKey {
   publicKey: Point
}

/**
 * Software-based BIP-32-like derivation for Grumpkin.
 * Matches the logic an HSM would use internally.
 */
export class InterimKeyRing {
   private readonly chainCode: Buffer
   private readonly preImage: Buffer
   private readonly _currentKeyPair?: KeyPair
   public readonly currentPublicKey: PublicKey

   constructor(masterSeed: Buffer, includePrivateKey: boolean = false) {
      // 1. Initial Master Derivation
      this.preImage = Buffer.alloc(41)
      this.preImage[0] = 0x00
      const master = hmacSha512(CURVE_SEED, masterSeed)
      const parentPriv = master.slice(0, 32)
      parentPriv.copy(this.preImage, 1)
      parentPriv.fill(0)

      this.chainCode = master.slice(32)
      master.fill(0)

      if (includePrivateKey) {
         this._currentKeyPair = {
            privateKey: GRUMPKIN_ZERO,
            publicKey: GRUMPKIN_G,
         }
      }
      this.currentPublicKey = {
         publicKey: GRUMPKIN_G,
      }
   }

   public get currentKeyPair(): KeyPair {
      if (this._currentKeyPair === undefined) {
         throw new Error("Only public keys are available")
      }
      return this._currentKeyPair
   }

   public async deriveKeyPair(index: number): Promise<void> {
      let chain = 0
      this.preImage.writeUInt32BE(index, 33) // Concat Index to parentPriv
      while (true) {
         // 2. Build the derivation path data: [ParentPriv][Index][Nonce]
         this.preImage.writeUInt32BE(chain, 37) // Rejection sequence index
         const I = hmacSha512(this.chainCode, this.preImage)
         const k_i = BigInt("0x" + I.slice(0, 32).toString("hex"))
         I.fill(0)

         // 3. Rejection Sampling
         if (k_i > 0 && k_i < GRUMPKIN_R) {
            const privateKey = new GrumpkinScalar(k_i)
            this.currentPublicKey.publicKey = await grumpkin.mul(
               GRUMPKIN_G,
               privateKey,
            )
            if (this._currentKeyPair !== undefined) {
               this._currentKeyPair.privateKey = privateKey
               this._currentKeyPair.publicKey = this.currentPublicKey.publicKey
            }
            return
         }
         chain++
         if (chain > 255)
            throw new Error(`Catastrophic entropy failure at index ${index}`)
      }
   }

   clean(): void {
      if (this._currentKeyPair !== undefined) {
         this._currentKeyPair.privateKey = GRUMPKIN_ZERO
         this._currentKeyPair.publicKey = GRUMPKIN_G
      }
      this.currentPublicKey.publicKey = GRUMPKIN_G
   }

   destroy(): void {
      this.clean()
      this.preImage.fill(0)
      this.chainCode.fill(0)
   }
}
