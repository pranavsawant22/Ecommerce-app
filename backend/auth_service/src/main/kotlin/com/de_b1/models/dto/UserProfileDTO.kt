package com.de_b1.models.dto

import kotlinx.serialization.Serializable

@Serializable
data class UserProfileDTO (
    val firstName: String,
    val lastName: String,
    val email: String,
    val phone: String
)