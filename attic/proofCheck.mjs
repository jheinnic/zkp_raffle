import {poseidon2Hash} from '@zkpassport/poseidon2'

const LEAF_DOMAIN = BigInt(0);
const INNER_DOMAIN = BigInt(1);

function verifyProof(proof) {
    let hash = poseidon2Hash([
      LEAF_DOMAIN,
      ...proof.leafItem,
    ]);
    let idx = proof.leafIndex;
    console.error("?? ", hash, " <=?=> ", proof.leafValue)
    let lvl = 0
    for (const sib of proof.siblings) {
      console.error("-- Calculation step ", lvl, " (", (idx & 1) === 0, "): ", (idx & 1) === 0 ? [INNER_DOMAIN, hash, sib] : [INNER_DOMAIN, sib, hash]);
      hash = poseidon2Hash((idx & 1) === 0 ? [INNER_DOMAIN, hash, sib] : [INNER_DOMAIN, sib, hash]);
      idx >>= 1;
    }
    console.error("## ", hash, " <=?=> ", proof.root)
    return hash === proof.root;
  }

const proof = {
   index: 1024,
   leafItem: [
	 BigInt("0x27a99696e262e541439d880fddd32c905ea60623b5a9e8a4c88fdc69252fe383"),
BigInt("0x1763001aaf9ef14654a1153aa72d6d98eefb37ffd8816058c8c322b428162596"),
	   BigInt(0)
   ],
   siblings: [
	   BigInt("0x26c110cebacad04f824c2181422c8c88dfbde1b466ff1e12d3026c91b6235aeb"), BigInt("0x0b6ff808cc1082f9783df5c482cf8e7519746204f98fb182db6255d6d9657828"), BigInt("0x18f8ded1e667e27f287a66d51f3b39672170d37563cf3f453222bd7874dc25ed"), BigInt("0x2c2ed1295c1e58040e606e83b9a55c5bffdd5b233db2d32fad4a8f4a3fb8661d"), BigInt("0x10a2a740b46e6bed46938f6d56fc9a5754779cb99e737ee39333ce88c027120c"), BigInt("0x03b13524b41ba06a191737acf263ce46347d396b5964d3414d6e9f26aedb7ea7"), BigInt("0x231a9f3bed809f187cf3ed466453d3b8e4d55dfa134aaf07e654f3578bb39b38"), BigInt("0x2551d5f3b0bf919acea8e2768b4097bc7c96f31b4fcb4d6e8b0f3978a8377ff5"), BigInt("0x103ed749436ce0dd934f03b75ad30af2f7e88ae604559f2507b017decf3bfa71"), BigInt("0x1943ff5d6fad566547c731791c63a8cfbe8d1d7016162e43909452bac350be43"), BigInt("0x1466be76a7efe38a7572101018093adf3b850e3ca85ecf18fea91eeb1cb1b9f9"), BigInt("0x216bbfd9622a7755f9bb1ae27537517feb72b9f93da3d083fe83fb100f3ababc"), BigInt("0x0bef366f0dbd16306d33ec76499dd0b26d315d4b91184ae4846462778fa84a05"), BigInt("0x14daffaabad1be0ede739c075ae8ec44383cdc1667efb1576b38cf16f1a63b00"), BigInt("0x05e64f08f9ea72b308b48e4390ca9a4a7362c1f00a77f1b00b1a7ed1fa8114a0"), BigInt("0x2a8980fd35768ec4a8c4af3c965d91b1c2c347c9f5db688ee85b1b37bb7938e6"), BigInt("0x1ca088f56a29b7949453abab3290c7105145f88f942f9cdb18f1f5dd85350315"), BigInt("0x151ad5292eef627c94274fe95756367b0986942fcac065b38321343c64a08d50"), BigInt("0x259422daabd8c5b42b7c8b6d71369a89a182e02702e2edcd5104e868b5640588"), BigInt("0x28bb5c2b18101393c317bdc43789de1b7305bf77c1cc890a19589707e157a738"), BigInt("0x2fbebb10ce246adabf0a30f770ad2f48f227ae28972bf78dc343383a3084f29c"), BigInt("0x0aedac7f23f8d049c54e79b3f2e16b4388003bbbb08f122ef4085d7b5a1283e4"), BigInt("0x22f42d6582472508e78946159ea0a782bb99aaa8df3fcfc6b736bb7698be70ee"), BigInt("0x0ebfd2348aede190731a16170c6e7b0108f0b9eddcce23a42ce6dd6689fe7816"), BigInt("0x2aae9a34aba9a2446b3e2cd35ef7b2bc4a092b8d95a260c52de94eb9e8b201a6"), BigInt("0x11b10c0ba0a2b30e351eafe11a57ec223c5cb5f914f21eab8e4aa6ff8ea82057")],
   root: BigInt("0x25e47fd1e6123de665d79f155f14e9a3b79b0f30e47d3f9c530809d2e39527a5")
}

verifyProof(proof);
