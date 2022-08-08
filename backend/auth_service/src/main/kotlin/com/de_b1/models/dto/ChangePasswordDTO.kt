package com.de_b1.models.dto

import kotlinx.serialization.Serializable

@Serializable
data class ChangePasswordDTO (
    val oldPassword:String,
    val newPassword:String
        )