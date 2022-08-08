package com.de_b1.models.dto

import com.de_b1.models.schema.TypeOfLogin
import kotlinx.serialization.Serializable

@Serializable
data class UserLoginDTO (
    val email:String,
    val password:String,
    var typeOfLogin: TypeOfLogin?=null,
    var client:String?=null
        )