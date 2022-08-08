package com.de_b1.services

import com.de_b1.models.ApplicationResponse
import com.de_b1.models.DTO.SkuIdDTO
import com.de_b1.models.schema.Wishlist
import com.de_b1.models.schema.WishlistItem
import com.de_b1.repositories.WishlistRepository
import io.ktor.http.*


class WishlistService {

    private val wishlistRepository = WishlistRepository()

    suspend fun checkWishlist(userid:String,postRequest: SkuIdDTO) : ApplicationResponse {

        val wishlist = wishlistRepository.findWishlistByUserId(userId = userid)

        if (wishlist == null) {
            //create a new wishlist for the user

            val item = WishlistItem(sku_id = postRequest.sku_id)
            val items = mutableListOf<WishlistItem>()
            items.add(item)
            val wishlist_obj = Wishlist(user_id = userid, wishlistItems = items)
            wishlistRepository.addWishlist(wishlist_obj)
            return ApplicationResponse(message = "New Wishlist created and item added to the wishlist", statusCode = HttpStatusCode.OK)
        } else {
            //wishlist found and adding product to it

            val checkSkuIdService = checkSkuId(userid, postRequest.sku_id)
            return if (checkSkuIdService != null) {
                //product already in the wishlist
                ApplicationResponse(message = "Item already in  the wishlist", statusCode = HttpStatusCode.OK)
            } else {
                wishlistRepository.addToWishlist(userid, postRequest)
                ApplicationResponse(message = "Item added to the wishlist", statusCode = HttpStatusCode.OK)
            }
        }
    }

    private suspend fun checkSkuId(userId: String, skuId: String?): Wishlist? {
        return wishlistRepository.findWishlistItemBySkuId(userId = userId, skuId = skuId)
    }

    suspend fun deleteWishlist(userId: String): ApplicationResponse {
        val isValidUser = wishlistRepository.findWishlistByUserId(userId)

        if (isValidUser!= null) {
            val isDeleted = wishlistRepository.deleteWishlistByUserId(userId)
            return if (isDeleted) {
                ApplicationResponse("Successfully deleted wishlist", HttpStatusCode.OK)
            } else {
                ApplicationResponse("Failed to delete wishlist", HttpStatusCode.OK)
            }
        } else
        {
            return ApplicationResponse("Invalid User", HttpStatusCode.BadRequest)
        }
    }

    suspend fun removeItemFromWishlist(userId: String, skuId: String): ApplicationResponse {

        val isValidUser = wishlistRepository.findWishlistByUserId(userId)

        if (isValidUser != null) {
            val wishlist = wishlistRepository.findWishlistByUserId(userId)
            val existingWishlistItems = wishlist!!.wishlistItems?.toMutableList()
            var item = WishlistItem(sku_id = null)
            for (item1 in existingWishlistItems!!) {

                if (item1.sku_id == skuId) {
                    item = item1
                }
            }
            existingWishlistItems.remove(item)
            wishlist.wishlistItems = existingWishlistItems
            val queryResponse = wishlistRepository.updateWishlist(wishlist)
            return if (queryResponse.modifiedCount > 0) {
                ApplicationResponse("Item removed from wishlist", HttpStatusCode.OK)
            } else {
                ApplicationResponse("Item not found", HttpStatusCode.OK)
            }
        } else {
            return ApplicationResponse("Invalid User", HttpStatusCode.BadRequest)
        }
    }
    suspend fun getWlService(userID:String): Wishlist? {
        val wl: Wishlist? = wishlistRepository.findWishlistByUserId(userID)
        return wl
    }

}
