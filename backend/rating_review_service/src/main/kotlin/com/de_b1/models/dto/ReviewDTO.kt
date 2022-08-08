package com.de_b1.models.dto

@kotlinx.serialization.Serializable
data class ReviewDTO(
    val productId:String?,
    var comment: String?,
    val skuId: String?
)