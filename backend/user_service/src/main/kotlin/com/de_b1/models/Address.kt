package com.de_b1.models

import kotlinx.serialization.Serializable
import java.util.*

@Serializable
data class Address(
    val _id : String = UUID.randomUUID().toString(),
    val name : String = "" ,
    val buildingInfo : String = "" ,
    val state : String  = "",
    val city : String = "",
    val landmark : String = "" ,
    val pincode : String = ""
)
