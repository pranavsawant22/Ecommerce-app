package com.de_b1.models.dto

import kotlinx.serialization.Serializable

@Serializable
data class SendOtpDTO (
    val email: String
)