package com.de_b1.models.dto

@kotlinx.serialization.Serializable
data class SkuIdAndProductIdDTO(
    val skuId: String? = null,
    val productId: String? = null
)