package com.de_b1.routes
import com.de_b1.models.ApplicationResponse
import com.de_b1.models.Schemas.RatingReview
import com.de_b1.models.dto.RatingAndReviewResponseDTO
import com.de_b1.models.dto.RatingDTO
import com.de_b1.models.dto.ReviewDTO
import com.de_b1.models.dto.SkuIdAndProductIdDTO
import com.de_b1.service.RatingAndReviewService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*


fun Route.ratingAndReviewRouting() {

    val ratingAndReviewService = RatingAndReviewService()

    route("/api/v1/rating-review") {

        get("/get-rating-review-for-order-item/{skuId}") {

            try {
                val userId: String? = call.request.headers["user_id"]
                val skuId: String? = call.parameters["skuId"]

                if (userId == null || userId.isEmpty()) {
                    call.respond(HttpStatusCode.BadRequest, "Invalid UserId")
                } else if (skuId == null || skuId.isEmpty()) {
                    call.respond(HttpStatusCode.BadRequest, "Invalid SkuId")
                } else {
                    val result =
                        ratingAndReviewService.getRatingReviewServiceWithSku(userId.toString(), skuId.toString())

                    if (result == null) {
                        //not rated nor reviewed yet
                        call.respond(HttpStatusCode.OK, "")
                    } else {
                        call.respond(HttpStatusCode.OK, result)
                    }
                }

            } catch (e: Exception) {
                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }

        }

        get("/get-rating-review-by-productid/{product_id}") {

            try {
                val productId: String? = call.parameters["product_id"]
                val applicationResponse: ApplicationResponse
                if ((productId == null) || (productId.isEmpty())) {
                    applicationResponse = ApplicationResponse("Invalid ProductId", HttpStatusCode.BadRequest)
                    call.respond(applicationResponse.statusCode, applicationResponse.message)
                } else {
                    val result: List<RatingReview?> =
                        ratingAndReviewService.getRatingReviewbyproductId(productId.toString())
                    val respondData = RatingAndReviewResponseDTO(
                        responseDTO = result
                    )

                    if (result.isEmpty()) {
                        call.respond(HttpStatusCode.OK, "")
                    } else {
                        call.respond(HttpStatusCode.OK, respondData.responseDTO)
                    }
                }
            } catch (e: Exception) {
                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }
        }


        delete("/delete-rating-review") {

            try {
                val userId: String? = call.request.headers["user_id"]

                val requestBody = call.receive<SkuIdAndProductIdDTO>()
                //errors
                val applicationResponse: ApplicationResponse
                if (userId == null || userId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid UserId", HttpStatusCode.BadRequest)
                } else if (requestBody.productId == null || requestBody.productId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid ProductId", HttpStatusCode.BadRequest)
                } else if (requestBody.skuId == null || requestBody.skuId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid SkuId", HttpStatusCode.BadRequest)
                } else {
                    val skuId: String = requestBody.skuId
                    val productId: String = requestBody.productId
                    applicationResponse = ratingAndReviewService.deleteRating(userId, skuId, productId)
                }

                call.respond(applicationResponse.statusCode, applicationResponse.message)
            } catch (e: Exception) {
                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }
        }


        delete("/delete-review") {

            try {
                val userId: String? = call.request.headers["user_id"]

                val requestBody = call.receive<SkuIdAndProductIdDTO>()

                val applicationResponse: ApplicationResponse

                if (userId == null || userId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid UserId", HttpStatusCode.BadRequest)
                } else if (requestBody.productId == null || requestBody.productId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid ProductId", HttpStatusCode.BadRequest)
                } else if (requestBody.skuId == null || requestBody.skuId.isEmpty()) {
                    applicationResponse = ApplicationResponse("Invalid SkuId", HttpStatusCode.BadRequest)
                } else {
                    val skuId: String = requestBody.skuId
                    val productId: String = requestBody.productId
                    applicationResponse = ratingAndReviewService.deleteReview(userId, skuId, productId)
                }
                call.respond(applicationResponse.statusCode, applicationResponse.message)
            } catch (e: Exception) {

                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }
        }


        post("/add-or-update-rating") {
            try {
                val userId: String? = call.request.headers["user_id"]
                val firstName: String? = call.request.headers["first_name"]
                val lastName: String? = call.request.headers["last_name"]
                val requestBody = call.receive<RatingDTO>()

                val applicationResponse: ApplicationResponse = if (userId == null || userId.isEmpty()) {
                    ApplicationResponse("Invalid UserId", HttpStatusCode.BadRequest)
                } else if ((requestBody.skuId == null) || requestBody.skuId.isEmpty()) {
                    ApplicationResponse("Invalid SkuId", HttpStatusCode.BadRequest)
                } else if ((requestBody.productId == null) || requestBody.productId.isEmpty()) {
                    ApplicationResponse("Invalid ProductId", HttpStatusCode.BadRequest)
                } else if ((requestBody.rating == null) || requestBody.rating!!.toInt() > 5 || requestBody.rating!! < 1) {
                    ApplicationResponse("Invalid rating", HttpStatusCode.BadRequest)
                } else if ((firstName == null ) || (firstName.isEmpty())) {
                    ApplicationResponse("Invalid firstName", HttpStatusCode.BadRequest)
                } else if ((lastName == null) || (lastName.isEmpty())) {
                    ApplicationResponse("Invalid lastName", HttpStatusCode.BadRequest)
                } else {
                    val skuId: String = requestBody.skuId
                    val productId: String = requestBody.productId
                    val rating: Int = requestBody.rating!!
                    ratingAndReviewService.addOrUpdateRating(userId, skuId, productId, rating, firstName, lastName)
                }
                call.respond(applicationResponse.statusCode, applicationResponse.message)

            } catch (e: Exception) {
                println(e)
                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }
        }
        post("/add-or-update-review") {
            try {
                val userId: String? = (call.request.headers["user_id"])
                val firstName: String? = call.request.headers["first_name"]
                val lastName: String? = call.request.headers["last_name"]
                val requestBody = call.receive<ReviewDTO>()
                val applicationResponse: ApplicationResponse = if (userId == null || userId.isEmpty()) {
                    ApplicationResponse("Invalid UserId", HttpStatusCode.BadRequest)
                } else if ((requestBody.skuId == null) || requestBody.skuId.isEmpty()) {
                    ApplicationResponse("Invalid SkuId", HttpStatusCode.BadRequest)
                } else if ((requestBody.productId == null) || requestBody.productId.isEmpty()) {
                    ApplicationResponse("Invalid ProductId", HttpStatusCode.BadRequest)
                } else if ((requestBody.comment == null) || requestBody.comment.toString().isEmpty()) {
                    ApplicationResponse("Invalid comment", HttpStatusCode.BadRequest)
                } else if ((firstName == null ) || (firstName.isEmpty())) {
                    ApplicationResponse("Invalid firstName", HttpStatusCode.BadRequest)
                } else if ((lastName == null) || (lastName.isEmpty())) {
                    ApplicationResponse("Invalid lastName", HttpStatusCode.BadRequest)
                } else {
                    val skuId: String = requestBody.skuId
                    val productId: String = requestBody.productId
                    val comment: String = requestBody.comment!!
                    ratingAndReviewService.addOrUpdateReview(userId.toString(), skuId, productId, comment, firstName, lastName)
                }

                call.respond(applicationResponse.statusCode, applicationResponse.message)
            } catch (e: Exception) {
                println(e)
                call.respond(HttpStatusCode.BadRequest, e.localizedMessage)
            }
        }
    }
}
