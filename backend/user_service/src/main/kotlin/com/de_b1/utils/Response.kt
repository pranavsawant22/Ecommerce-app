package com.de_b1.utils

import com.de_b1.models.AddressesWithSerialId
import kotlinx.serialization.Serializable

@Serializable
data class ResponseFailure(
    val success : Boolean,
    val message : String?
)

@Serializable
data class ResponseSuccess(
    val success : Boolean,
    val addresses : AddressesWithSerialId
)