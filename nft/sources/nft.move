/// Módulo: Badge NFT - Seu primeiro NFT de verdade! (VERSÃO COMPLETA)
/// Objetivo: Criar um badge (crachá) NFT com Display personalizado
module nft::badge_nft {
    // ===== Imports =====
    use sui::display;
    use std::string::{Self, String};
    use sui::package::{Self, Publisher};

    // ===== Structs =====
    
    /// One-Time Witness (Testemunha Única)
    /// Este é nosso "selo especial" que prova que somos os criadores
    /// Só pode ser usado UMA vez, na função init
    public struct BADGE_NFT has drop {}

    /// A estrutura do nosso Badge NFT
    /// Representa um crachá digital na blockchain
    public struct BadgeNFT has key, store {
        id: UID,
        name: String,
        description: String,
        url: String,
    }

    // ===== Função de Inicialização =====
    
    /// Esta função roda AUTOMATICAMENTE quando publicamos o contrato
    /// Ela cria o Publisher (certificado de autoria)
    fun init(otw: BADGE_NFT, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
    }

    // ===== Entry Functions =====
    
    /// Cria (minta) um novo Badge NFT
    /// Esta é a função que os usuários vão chamar para criar badges
    public entry fun mint(
        name: vector<u8>,
        description: vector<u8>, 
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let badge = BadgeNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: string::utf8(url),
        };

        transfer::public_transfer(badge, tx_context::sender(ctx));
    }

    /// Cria o Display - a "vitrine" do NFT
    /// Define como o badge vai aparecer nas carteiras
    public entry fun create_display(
        publisher: &Publisher,
        ctx: &mut TxContext
    ) {
        let mut display = display::new_with_fields<BadgeNFT>(
            publisher,
            vector[
                string::utf8(b"name"),
                string::utf8(b"description"),
                string::utf8(b"image_url")
            ],
            vector[
                string::utf8(b"{name}"),
                string::utf8(b"{description}"),
                string::utf8(b"{url}")
            ],
            ctx
        );

        display::update_version(&mut display);
        transfer::public_transfer(display, tx_context::sender(ctx));
    }
}