use std::embedded_curve_ops::{EmbeddedCurvePoint, EmbeddedCurveScalar, multi_scalar_mul, fixed_base_scalar_mul};
use dep::merkle::{MAX_DEPTH,verifyProof};

global TREE_DEPTH: u32 = MAX_DEPTH;

global PRIZE_DOMAIN: Field = 3;

// Max usable field value
// global NOIR_FIELD_MAX: Field = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000;

fn main(
    // Public Inputs
    tickets_merkle_root: pub Field,
    raffle_pubkey_x: pub Field,
    raffle_pubkey_y: pub Field,
    prize_ecdhkey_hash: pub Field,
    
    // Private Inputs
    index: Field,
    index_bits: [bool; TREE_DEPTH],
    ticket_priv_key: Field,
    ticket_pubkey_x: Field,
    ticket_pubkey_y: Field,
    ticket_pubkey_hash: Field,
    path: [Field; TREE_DEPTH],
    prize_ecdhkey_x: Field,
    prize_ecdhkey_y: Field,
) {
    // Reassemble/Unpack Embedded Curve types
    // verify_key_range(ticket_priv_key);
    let ticket_priv_scalar = EmbeddedCurveScalar::from_field(ticket_priv_key);
    let raffle_pub_point = EmbeddedCurvePoint { x: raffle_pubkey_x, y: raffle_pubkey_y, is_infinite: false };

    // 1. Prove Ticket Membership: The Ticket PubKey is in the Merkle Tree
    verifyProof(index, index_bits, [ticket_pubkey_x, ticket_pubkey_y], path, tickets_merkle_root);
    // prove_ticket_commitment(index, index_bits, ticket_pubkey_hash, path, tickets_merkle_root);

    // 2. Prove Reveal Key Authority: ticket_priv_key corresponds to ticket_pubkey
    validate_ticket_point(ticket_priv_scalar, ticket_pubkey_x, ticket_pubkey_y);

    // 3. Prove Prize Point is derived from ticket_priv_key
    validate_prize_point(ticket_priv_scalar, raffle_pub_point, prize_ecdhkey_x, prize_ecdhkey_y, prize_ecdhkey_hash)
}

fn validate_ticket_point(
    ticket_priv_scalar: EmbeddedCurveScalar, 
    ticket_pub_x: Field,
    ticket_pub_y: Field
) {
    // 3. Link Reveal Key to Prize Point: dBi * PA = prize_ecdhkey_k
    // We treat the Ticket Private Key as a scalar
    let ticket_point = fixed_base_scalar_mul(ticket_priv_scalar);
    assert(ticket_point.x == ticket_pub_x);
    assert(ticket_point.y == ticket_pub_y);
}

fn validate_prize_point(
    ticket_priv_scalar: EmbeddedCurveScalar, 
    raffle_pub_point: EmbeddedCurvePoint,
    prize_ecdh_x: Field,
    prize_ecdh_y: Field,
    prize_ecdh_hash: Field
) {
    // Derive the Prize's Shared (Diffie-Hellman) Point
    let prize_point = multi_scalar_mul([raffle_pub_point], [ticket_priv_scalar]);
    assert(prize_point.x == prize_ecdh_x);
    assert(prize_point.y == prize_ecdh_y);

    let prize_point_hash = poseidon::poseidon2::Poseidon2::hash([PRIZE_DOMAIN, prize_point.x, prize_point.y], 3);
    assert(prize_point_hash == prize_ecdh_hash)
}

// fn verify_key_range(priv_scalar: Field) {
    // Noir's Field is already mod r, so any 'Field' is technically < r.
    // However, if you pass it as a witness, Nargo ensures it's canonical.
    // For absolute clarity in your logic:
//     assert(priv_scalar <= NOIR_FIELD_MAX);
// }

#[test]
fn test_main() {
    // main(1, 2);

    // Uncomment to make test fail
    // main(1, 1);
}
