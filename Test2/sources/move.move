module nft::nft {

    use std::string::{Self, String};
    use sui::package;

    public struct BADGE_NFT has drop{} 

    public struct MEU_NFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: String,

    }

    fun init() {
        
    }


}
