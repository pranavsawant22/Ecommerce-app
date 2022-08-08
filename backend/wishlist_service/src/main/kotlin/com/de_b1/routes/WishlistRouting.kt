package com.de_b1.routes

import com.de_b1.models.ApplicationResponse
import com.de_b1.models.DTO.SkuIdDTO
import com.de_b1.models.DTO.WishlistResponseDTO
import com.de_b1.models.schema.Wishlist
import com.de_b1.services.WishlistService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*


fun Route.wishlistRouting() {

    route("api/v1/wishlist") {
        post("/add-wishlist") {
            try {
                val userId: String? = call.request.headers["user_id"]
                val postRequest = call.receive<SkuIdDTO>()
                val applicationResponse: ApplicationResponse
                if ((postRequest.sku_id == null) || postRequest.sku_id.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid SkuId", HttpStatusCode.BadRequest)
                } else if (userId == null || userId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid UserId", HttpStatusCode.BadRequest)
                } else {
                    applicationResponse = WishlistService().checkWishlist(userId.toString(), postRequest)
                }
                call.respond(applicationResponse.statusCode, applicationResponse.message)
            } catch (e: Exception) {
                println(e)
                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }
        }

        delete("/delete-wishlist") {

            try {
                val userId: String? = call.request.headers["user_id"]

                val applicationResponse : ApplicationResponse = if(userId == null || userId.isEmpty()){
                    ApplicationResponse("Invalid UserId", HttpStatusCode.BadRequest)
                } else{
                    WishlistService().deleteWishlist( userId.toString())
                }
                call.respond(applicationResponse.statusCode,applicationResponse.message)
            }
            catch (e:Exception) {
                println(e)
                call.respond(HttpStatusCode.BadRequest,e.localizedMessage)
            }
        }

        put("/remove-item-from-wishlist") {

            try {
                val userId: String? = call.request.headers["user_id"]
                val requestBody = call.receive<SkuIdDTO>()
                val applicationResponse : ApplicationResponse = if(userId == null || userId.isEmpty()){
                    ApplicationResponse( "Invalid UserId" , HttpStatusCode.BadRequest)
                }
                else  if((requestBody.sku_id == null) || requestBody.sku_id.isEmpty()) {
                    ApplicationResponse( "Invalid SkuId" , HttpStatusCode.BadRequest)
                } else {
                    val skuId: String = requestBody.sku_id
                    WishlistService().removeItemFromWishlist(userId,skuId)
                }
                call.respond(applicationResponse.statusCode,applicationResponse.message)

            } catch (e:Exception) {
                println(e)
                call.respond(HttpStatusCode.BadRequest,e.localizedMessage)
            }
        }
        get("/get-wishlist") {
            val userId: String? = (call.request.headers["user_id"])
            if (userId == null || userId == "")
                call.respond(HttpStatusCode.BadRequest, "Invalid Request")
            val ser = WishlistService()
            val wl: Wishlist? = ser.getWlService(userId.toString())
            val resp = WishlistResponseDTO(
                id = wl?._id.toString(),
                userid = wl?.user_id.toString(),
                wishlistitems = wl?.wishlistItems
            )
            if (wl == null) {
                call.respond(HttpStatusCode.NotFound, "No items found, add items to wishlist!")
            }
            call.respond(HttpStatusCode.OK, resp)
        }
    }
}
