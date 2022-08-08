package com.de_b1.models.dto

import kotlinx.serialization.Serializable

@Serializable
class UpdatePasswordDTO(
    val newPassword: String
)
