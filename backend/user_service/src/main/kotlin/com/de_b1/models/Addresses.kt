package com.de_b1.models

import kotlinx.serialization.Serializable
import java.util.UUID
import kotlin.collections.ArrayList

@Serializable
data class Addresses(
    val _id : String = UUID.randomUUID().toString(),
    val userId : String = "",
    val addresses : ArrayList<Address>
)
