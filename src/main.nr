use std::embedded_curve_ops::{EmbeddedCurvePoint, EmbeddedCurveScalar, multi_scalar_mul, fixed_base_scalar_mul};

global TREE_DEPTH: u32 = 24;

fn validate_ticket_point(
    ticket_priv_key: EmbeddedCurveScalar, 
    ticket_pub_x: Field, 
    ticket_pub_y: Field,
) {
    // 1. Derive the Ticket Private Key's Public Point
    // We treat the Ticket Private Key as a scalar
    let ticket_point = fixed_base_scalar_mul(ticket_priv_key);
    assert(ticket_point.x == ticket_pub_x);
    assert(ticket_point.y == ticket_pub_y);
}

fn validate_prize_point(
    ticket_priv_key: EmbeddedCurveScalar, 
    raffle_pub_point: EmbeddedCurvePoint,
    prize_pub_x: Field,
    prize_pub_y: Field
) {
    // Derive the Prize's Shared (Diffie-Hellman) Point
    let prize_point = multi_scalar_mul([raffle_pub_point], [ticket_priv_key]);
    assert(prize_point.x == prize_pub_x);
    assert(prize_point.y == prize_pub_y);

    // 2. Hash the result into a Merkle Leaf using Poseidon2
    // We use the X-coordinate of the shared secret as the entropy
    // let leaf = poseidon::poseidon1::Poseidon2::hash([
    //     shared_point.x, 
    //     pub_x, 
    //     pub_y
    // ], 2);

    // assert(leaf == expected_leaf);
}

fn main(
    // Public Inputs
    tickets_merkle_root: pub Field,
    raffle_pubkey_x: pub Field,
    raffle_pubkey_y: pub Field,
    prize_ecdhkey_x: pub Field,
    prize_ecdhkey_y: pub Field,
    
    // Private Inputs
    index: Field,
    index_bits: [u1; TREE_DEPTH],
    ticket_priv_key: Field,
    ticket_pubkey_x: Field,
    ticket_pubkey_y: Field,
    path: [Field; TREE_DEPTH] // Depth for ~1M tickets
) {
    // 0. Cheaply verify the bits sum to the index
    let mut reconstructed_index: Field = 0;
    let mut power_of_two: Field = 1;
    
    for i in 0..TREE_DEPTH {
        // Noir will optimize (bit * power) as a single gate
        reconstructed_index += (index_bits[i] as Field) * power_of_two;
        power_of_two *= 2;
    }
    
    // This assertion ensures index bits and value are consistent
    assert(reconstructed_index == index);

    // Reassemble/Unpack Embedded Curve types
    let ticket_priv_key = EmbeddedCurveScalar::from_field(ticket_priv_key);
    let raffle_pub_point = EmbeddedCurvePoint { x: raffle_pubkey_x, y: raffle_pubkey_y, is_infinite: false };

    // 1. Prove Ticket Membership: The Ticket PubKey is in the Merkle Tree
    let leaf = std::hash::poseidon::bn254::hash_2([ticket_pubkey_x, ticket_pubkey_y]);
    assert(std::merkle::check_membership(tickets_merkle_root, leaf, index, path));

    // 2. Prove Reveal Key Authority: ticket_priv_key corresponds to ticket_pubkey
    validate_ticket_point(ticket_priv_key, ticket_pubkey_x, ticket_pubkey_y);

    // 3. Link Reveal Key to Prize Point: dBi * PA = prize_ecdhkey_k
    validate_prize_point(ticket_priv_key, raffle_pub_point, prize_ecdhkey_x, prize_ecdhkey_y);
}

#[test]
fn test_main() {
    // main(1, 2);

    // Uncomment to make test fail
    // main(1, 1);
}
