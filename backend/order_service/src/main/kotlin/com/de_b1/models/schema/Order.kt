package com.de_b1.models.schema

import java.util.*

@kotlinx.serialization.Serializable
data class Order(
    var _id:String = UUID.randomUUID().toString(),
    var userId:String?="",
    var address:Address?,
    var totalPrice:Int? =0,
    var items: MutableList<OrderItem>,
    var status:String
)

@kotlinx.serialization.Serializable
data class OrderItem(
    val _id:String= UUID.randomUUID().toString(),
    var skuId:String="",
    var price:Int=0
)
@kotlinx.serialization.Serializable
data class Address(
    var addressId:String? =null,
    var building:String? =null,
    var state:String? =null,
    var city:String? =null,
    var landmark:String? =null,
    var pincode:String? =null
)
@kotlinx.serialization.Serializable
enum class Status(val status:String) {
    DELIVERED("Delivered"),
    NOT_SHIPPED("Not Shipped"),
    CANCELLED("Cancelled"),
}

