package com.de_b1.models

import kotlinx.serialization.Serializable
import java.util.*

@Serializable
data class AddressWithSerialId(
    val _id : String = UUID.randomUUID().toString(),
    val serialId : Int = -1,
    val name : String = "",
    val buildingInfo : String = "",
    val state : String  = "",
    val city : String = "",
    val landmark : String = "",
    val pincode : String = ""
)
