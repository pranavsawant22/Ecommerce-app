package com.de_b1.models.dto

import kotlinx.serialization.Serializable

@Serializable
data class ValidateOtpDTO (
    val email: String,
    val otp: String
)