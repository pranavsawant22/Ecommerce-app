package com.de_b1.repositories
import com.de_b1.config.MongoConfig
import com.de_b1.models.Schemas.RatingReview
import com.mongodb.client.result.UpdateResult
import org.litote.kmongo.and
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq
import org.litote.kmongo.set
import org.litote.kmongo.setTo

class RatingReviewRepository {
    private val ratingReviewCollection: CoroutineCollection<RatingReview> = MongoConfig.getDatabase().getCollection()
    suspend fun findRatingandReviewByuserIdskuIdproductId(userId: String, skuId: String, productId: String): RatingReview? {
        val temp= ratingReviewCollection.findOne(RatingReview::userId eq userId,RatingReview::skuId eq skuId,RatingReview::productId eq productId)
        return temp
    }

    suspend fun findRatingandReviewByuserIdskuId(userId: String, skuId: String): RatingReview? {
        val temp= ratingReviewCollection.findOne(RatingReview::userId eq userId,RatingReview::skuId eq skuId)
        return temp
    }

    suspend fun getallratingsandreviews(productId: String): List<RatingReview?> {
        val temp= ratingReviewCollection.find(RatingReview::productId eq productId).toList()

        return temp
    }
    suspend fun deleteRating(userId: String, skuId: String, productId: String) {
        ratingReviewCollection.deleteOne(RatingReview::userId eq userId,RatingReview::skuId eq skuId,RatingReview::productId eq productId)
    }
    suspend fun deleteReview(userId: String, skuId: String, productId: String) {
        val temp= ratingReviewCollection.findOne(RatingReview::userId eq userId,RatingReview::skuId eq skuId,RatingReview::productId eq productId)
        if (temp != null) {ratingReviewCollection.deleteOne(RatingReview::userId eq userId,RatingReview::skuId eq skuId,RatingReview::productId eq productId)
                temp.comment=""
                ratingReviewCollection.save(temp)}
    }

    suspend fun updateRating(rating: RatingReview) : UpdateResult {
        return ratingReviewCollection.updateOne(and(RatingReview::userId eq rating.userId,RatingReview::skuId eq rating.skuId,RatingReview::productId eq rating.productId),
            set(RatingReview::rating setTo rating.rating,RatingReview::firstName setTo rating.firstName,RatingReview::lastName setTo rating.lastName)
        )
    }

    suspend fun addRating(rating: RatingReview) {
        ratingReviewCollection.insertOne(rating)
    }

    suspend fun updateReview(review: RatingReview): UpdateResult {
        return ratingReviewCollection.updateOne(and( RatingReview::userId eq review.userId, RatingReview::skuId eq review.skuId, RatingReview::productId eq review.productId),
            set(RatingReview::comment setTo review.comment, RatingReview::firstName setTo review.firstName, RatingReview::lastName setTo review.lastName)
        )
    }

}

