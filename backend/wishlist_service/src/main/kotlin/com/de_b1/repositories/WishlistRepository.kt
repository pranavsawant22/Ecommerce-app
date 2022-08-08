package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.DTO.SkuIdDTO
import com.de_b1.models.schema.Wishlist
import com.de_b1.models.schema.WishlistItem
import com.mongodb.client.result.UpdateResult
import org.litote.kmongo.*


class WishlistRepository {
    private var wishlistCollection = MongoConfig.getDatabase().getCollection<Wishlist>()

    suspend fun addWishlist(Wishlist : Wishlist) : Wishlist{
        wishlistCollection.insertOne(Wishlist)
        return Wishlist
    }
    suspend fun addToWishlist(userId: String?, skuidDTO: SkuIdDTO): Wishlist? {
        return wishlistCollection.findOneAndUpdate(Wishlist::user_id eq userId ,
            push( Wishlist::wishlistItems,   WishlistItem(sku_id = skuidDTO.sku_id) )
        )
    }
    suspend fun findWishlistItemBySkuId(userId: String, skuId:String?) : Wishlist?{
        return wishlistCollection.findOne(and(Wishlist::user_id eq userId,Wishlist::wishlistItems/ WishlistItem::sku_id eq skuId))
    }

    suspend fun deleteWishlistByUserId(userId: String): Boolean {
        return wishlistCollection.deleteOne(Wishlist::user_id eq userId).wasAcknowledged()
    }
    suspend fun updateWishlist(wishlist: Wishlist): UpdateResult {
        return wishlistCollection.updateOne(Wishlist::user_id eq wishlist.user_id,
            set(Wishlist::wishlistItems setTo wishlist.wishlistItems)
        )
    }
    suspend fun findWishlistByUserId(userId: String): Wishlist? {
        return wishlistCollection.findOne(Wishlist::user_id eq userId)
    }

}

