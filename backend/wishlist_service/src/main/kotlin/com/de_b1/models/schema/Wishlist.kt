package com.de_b1.models.schema

import java.util.*

@kotlinx.serialization.Serializable
data class Wishlist(
    val _id:String = UUID.randomUUID().toString(),
    val user_id:String,
    var wishlistItems : MutableList<WishlistItem>? = mutableListOf()
)

@kotlinx.serialization.Serializable
data class WishlistItem(
    val _id:String= UUID.randomUUID().toString(),
    val sku_id:String?
)

