

module test3::teste_print {

use sui::debug::print;
use sui::string::utf8;

fun print_mess() {
    print(&utf8(b"Hello test!"))
}

#[test] 
fun test_print() {
    print_mess()
}

}