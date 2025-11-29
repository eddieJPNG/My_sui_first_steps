/*
/// Module: test2
module test2::test2;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


/*
/// Module: sui2
module sui2::sui2;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions



module test2::sui2{

    use std::string::String;

    public struct HelloMessage has key, store{
        id: UID,
        text: String,
    }

    public entry fun create_message(
        text: String,
        ctx: &mut TxContext
    ) {
        let message = HelloMessage {
            id: object::new(ctx),
            text: text,
        };

        transfer::transfer(message, tx_context::sender(ctx));
    }


}
