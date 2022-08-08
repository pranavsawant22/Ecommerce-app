package com.de_b1.models.Collections

@kotlinx.serialization.Serializable
data class SearchOutput(
    val name: String,
    val description: String,
    val brand: String,
    val rating: String,
    val kind: String,
    val productSkuName: String,
    val price: String,
    val image_url: String,
    val slug: String,
    val gender: String ?,
)

