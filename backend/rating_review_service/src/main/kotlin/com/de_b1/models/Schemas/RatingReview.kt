package com.de_b1.models.Schemas

import java.util.*

@kotlinx.serialization.Serializable
data class RatingReview(

    val _id:String = UUID.randomUUID().toString(),
    val productId:String?,
    val userId:String?,
    var rating:Int?,
    var comment: String?,
    val skuId: String?,
    var firstName: String?,
    var lastName: String?
)
