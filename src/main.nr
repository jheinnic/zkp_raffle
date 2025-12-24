use std::embedded_curve_ops::{EmbeddedCurvePoint, EmbeddedCurveScalar, multi_scalar_mul, fixed_base_scalar_mul};
use dep::merkle::{MAX_DEPTH,verifyProof};

global TREE_DEPTH: u32 = MAX_DEPTH;

global TICKET_DOMAIN: Field = 0;
global PRIZE_DOMAIN: Field = 3;

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

    // 1. Prove that this ticket's private scalar * Grumpkin's generator is the curve point used as this ticket's
    //    Poseidon2 pre-image in the raffle inventory Merkle tree.
    validate_ticket_point(ticket_priv_scalar, ticket_pubkey_x, ticket_pubkey_y, ticket_pubkey_hash);

    // 2. Prove Ticket is committed to Raffle Inventory Merkle Tree: The Ticket PubKey Hash is in the Merkle Tree
    verifyProof(index, index_bits, [ticket_pubkey_x, ticket_pubkey_y, 0], path, tickets_merkle_root);

    // 3. Prove that the public prize hash in this proof is its ticket's prize because the point that is its pre-image
    //    is the raffle's public point multiplied by this ticket's private scalar.
    validate_prize_point(ticket_priv_scalar, raffle_pub_point, prize_ecdhkey_x, prize_ecdhkey_y, prize_ecdhkey_hash)
}

fn validate_ticket_point(
    ticket_priv_scalar: EmbeddedCurveScalar, 
    ticket_pub_x: Field,
    ticket_pub_y: Field,
    ticket_pub_hash: Field
) {
    // 3. Link Reveal Key to Prize Point: dBi * PA = prize_ecdhkey_k
    // We treat the Ticket Private Key as a scalar
    let ticket_point = fixed_base_scalar_mul(ticket_priv_scalar);
    assert(ticket_point.x == ticket_pub_x);
    assert(ticket_point.y == ticket_pub_y);
    let ticket_hash = poseidon::poseidon2::Poseidon2::hash([TICKET_DOMAIN, ticket_pub_x, ticket_pub_y, (ticket_point.is_infinite as Field)], 4);
    assert(ticket_hash == ticket_pub_hash)
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

    let prize_point_hash = poseidon::poseidon2::Poseidon2::hash([PRIZE_DOMAIN, prize_point.x, prize_point.y, 0], 4);
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
