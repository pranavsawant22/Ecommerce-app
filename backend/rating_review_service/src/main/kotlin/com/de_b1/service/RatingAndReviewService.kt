package com.de_b1.service

import com.de_b1.models.ApplicationResponse
import com.de_b1.models.Schemas.RatingReview
import com.de_b1.repositories.RatingReviewRepository
import io.ktor.http.*

class RatingAndReviewService {

    private val ratingReviewRepository = RatingReviewRepository()

    suspend fun getRatingReviewServiceWithSku(userId: String, skuId: String): RatingReview? {

        return ratingReviewRepository.findRatingandReviewByuserIdskuId(userId, skuId)
    }

    suspend fun getRatingReviewbyproductId(productId: String): List<RatingReview?> {
        return ratingReviewRepository.getallratingsandreviews(productId)
    }

    suspend fun deleteRating(userId: String, skuId: String, productId: String) : ApplicationResponse{

        val ratingExists =  ratingReviewRepository.findRatingandReviewByuserIdskuIdproductId(userId,skuId,productId)

        return if (ratingExists != null) {
            ratingReviewRepository.deleteRating(userId, skuId, productId)
            ApplicationResponse("Deleted rating and review", HttpStatusCode.OK)
        }
        else {
            ApplicationResponse("User hasn't rated this product or already deleted", HttpStatusCode.BadRequest)
        }
    }

    suspend fun deleteReview(userId: String, skuId: String, productId: String) : ApplicationResponse  {

        val ratingExists =  ratingReviewRepository.findRatingandReviewByuserIdskuIdproductId(userId,skuId,productId)

        return if (ratingExists != null  ) {

            if(ratingExists.comment == null || ratingExists.comment!!.isEmpty()){

                ApplicationResponse("User hasn't written a review for this product", HttpStatusCode.BadRequest)
            }
            else{
                ratingReviewRepository.deleteReview(userId, skuId, productId)
                ApplicationResponse("Review removed", HttpStatusCode.OK)
            }
        }
        else {
            ApplicationResponse("User hasn't written a review for this product or already deleted", HttpStatusCode.BadRequest)
        }

    }

    suspend fun addOrUpdateRating(userId: String, skuId: String, productId: String, rating: Int, firstName: String, lastName: String): ApplicationResponse {

        val existingRatingReview =
            ratingReviewRepository.findRatingandReviewByuserIdskuIdproductId(userId, skuId, productId)

        if (existingRatingReview != null) {
            val ratingReview = RatingReview(
                userId = userId,
                productId = productId,
                skuId = skuId,
                rating = rating,
                comment = existingRatingReview.comment,
                firstName = firstName,
                lastName = lastName
            )
            println(existingRatingReview)
            val queryResponse = ratingReviewRepository.updateRating(ratingReview)
            if (queryResponse.modifiedCount > 0) {
                return ApplicationResponse("Rating updated", HttpStatusCode.OK)
            } else {
                return ApplicationResponse("No rating to update", HttpStatusCode.OK)
            }
        } else {
            val ratingReview = RatingReview(
                userId = userId,
                productId = productId,
                skuId = skuId,
                rating = rating,
                comment = existingRatingReview?.comment,
                firstName = firstName,
                lastName = lastName
            )
            println(ratingReview)
            ratingReviewRepository.addRating(ratingReview)
            return ApplicationResponse("Rating added", HttpStatusCode.OK)
        }
    }

    suspend fun addOrUpdateReview(
        userId: String,
        skuId: String,
        productId: String,
        comment: String,
        firstName: String,
        lastName: String
    ): ApplicationResponse {

        val existingRatingReview =
            ratingReviewRepository.findRatingandReviewByuserIdskuIdproductId(userId, skuId, productId)

            if (existingRatingReview != null ) {


                val ratingReview = RatingReview(
                    userId = userId,
                    productId = productId,
                    skuId = skuId,
                    rating = existingRatingReview.rating,
                    comment = comment,
                    firstName = firstName,
                    lastName = lastName
                )
                val queryResponse = ratingReviewRepository.updateReview(ratingReview)
                return if (existingRatingReview.comment==null){
                    ApplicationResponse("Review added",HttpStatusCode.OK)
                } else {

                    if (queryResponse.modifiedCount > 0) {
                        ApplicationResponse("Review updated", HttpStatusCode.OK)
                    } else {
                        ApplicationResponse("No review to update", HttpStatusCode.OK)
                    }
                }
            }
            else {

            return ApplicationResponse("Add a rating first", HttpStatusCode.BadRequest)
        }
    }
}
