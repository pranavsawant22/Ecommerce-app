package com.de_b1.models

import kotlinx.serialization.Serializable
import java.util.*
import kotlin.collections.ArrayList


@Serializable
data class CartItem(
        val cart_item_id:String = UUID.randomUUID().toString(),
        val sku_id:String?,
        val quantity:Int?
)



@Serializable
data class Cart(
        val _id: String = UUID.randomUUID().toString(),
        val user_id:String?,
        var cart_items: ArrayList<CartItem>
)

@Serializable
data class CartQty(val sku_id:String?,val quantity: Int?)


@Serializable
data class CartItemDelete(val sku_id: String?)