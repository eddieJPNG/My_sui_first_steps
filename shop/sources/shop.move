// teste de ia para apredizado para venda de itens de informatica


module shop::computer_shop {
 
    use sui::display;
    use std::string::{Self, String};
    use sui::package::{Self, Publisher};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

   
    public struct COMPUTER_SHOP has drop {}

    // Item de informática
    public struct ComputerItem has key, store {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        image_url: String,
    }

    // Recibo de compra
    public struct PurchaseReceipt has key, store {
        id: UID,
        item_name: String,
        purchase_date: u64,
        price_paid: u64,
        buyer: address,
    }

    // Shop principal
    public struct Shop has key {
        id: UID,
        owner: address,
        balance: u64,
        total_sales: u64,
    }


    fun init(otw: COMPUTER_SHOP, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);
        
        let shop = Shop {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            balance: 0,
            total_sales: 0,
        };

        transfer::share_object(shop);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
    }


    // Adicionar novo item na loja
    public entry fun add_item(
        shop: &mut Shop,
        name: vector<u8>,
        description: vector<u8>,
        price: u64,
        stock: u64,
        image_url: vector<u8>,
        ctx: &mut TxContext
    ) {
        assert!(shop.owner == tx_context::sender(ctx), 1); // Apenas owner pode adicionar itens

        let item = ComputerItem {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            price,
            stock,
            image_url: string::utf8(image_url),
        };

        transfer::share_object(item);
    }


    // Comprar item
    public entry fun buy_item(
        shop: &mut Shop,
        item: &mut ComputerItem,
        payment: Coin<SUI>,
        ctx: &mut TxContext
    ) {
        // Verificar estoque
        assert!(item.stock > 0, 2);

        let price = item.price;
        let payment_amount = coin::value(&payment);

        // Verificar pagamento
        assert!(payment_amount >= price, 3);

        // Atualizar estoque
        item.stock = item.stock - 1;

        // Atualizar saldo da loja
        shop.balance = shop.balance + price;
        shop.total_sales = shop.total_sales + 1;

        // Criar recibo
        let receipt = PurchaseReceipt {
            id: object::new(ctx),
            item_name: item.name,
            purchase_date: tx_context::epoch(ctx),
            price_paid: price,
            buyer: tx_context::sender(ctx),
        };

        // Enviar recibo para o comprador
        transfer::public_transfer(receipt, tx_context::sender(ctx));

        // Enviar moeda para o owner
        transfer::public_transfer(payment, shop.owner);
    }


    // Verificar saldo da loja
    public fun get_shop_balance(shop: &Shop): u64 {
        shop.balance
    }


    // Verificar total de vendas
    public fun get_total_sales(shop: &Shop): u64 {
        shop.total_sales
    }


    // Verificar estoque de um item
    public fun get_item_stock(item: &ComputerItem): u64 {
        item.stock
    }


    // Verificar preço de um item
    public fun get_item_price(item: &ComputerItem): u64 {
        item.price
    }
}