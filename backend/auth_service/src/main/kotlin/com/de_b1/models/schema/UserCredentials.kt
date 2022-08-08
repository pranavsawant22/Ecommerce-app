package com.de_b1.models.schema
import java.util.*

data class UserCredentials(
    val _id: String = UUID.randomUUID().toString(),
    val userId: String,
    val email: String,
    var firstName:String?,
    var lastName: String?,
    var passwordHash: String,
    var jwtAccessToken: String? = null,
    var isLoggedIn: Boolean,
    var jwtExpiryDate: Date = Date(System.currentTimeMillis())
)
