package com.de_b1.models

import com.de_b1.models.AddressWithSerialId
import kotlinx.serialization.Serializable
import java.util.*
import kotlin.collections.ArrayList

@Serializable
data class AddressesWithSerialId(
    val _id : String = UUID.randomUUID().toString(),
    val userId : String = "",
    val addresses : ArrayList<AddressWithSerialId>
)
