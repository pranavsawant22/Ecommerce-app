package com.de_b1.models.schema

import java.time.LocalDateTime
import java.util.*

data class LoginHistory(
    val _id:String = UUID.randomUUID().toString(),
    val userId: String,
    var attemptedLogin: LocalDateTime? = LocalDateTime.now(),
    var success: Boolean,
    var client: String? = null,
    var typeOfLogin: TypeOfLogin
    )