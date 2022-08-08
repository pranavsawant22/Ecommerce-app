package com.de_b1.utils

import com.de_b1.models.Cart


@kotlinx.serialization.Serializable
data class ResponseSucess(val data: Cart, val success:Boolean)

@kotlinx.serialization.Serializable
data class ResponseFailure(val data: String, val success:Boolean)
