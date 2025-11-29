/*
/// Module: suitest
module suitest::suitest;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module hellosui::hellopiaui {

use std::debug::print;
use std::string::utf8;

fun pratica(){
    print(&utf8(b"Hello Piaui!"))
}

#[test]
fun test() {
    pratica()
}

fun test2() {
    print(&utf8(b"Hey guy!"))
}

#[test]
fun testando() {
    test2()
}

}