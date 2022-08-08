package com.de_b1.models.dto

import com.de_b1.models.schema.RandomToken
import com.de_b1.models.schema.TypeOfLogin
import kotlinx.serialization.Serializable

@Serializable
data class RegisterDTO (
    val firstName: String,
    val lastName: String,
    val email: String,
    var password: String,
    val phone: String,
    var randomTokenString: String? = null
)
