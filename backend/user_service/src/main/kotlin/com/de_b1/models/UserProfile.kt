package com.de_b1.models

import kotlinx.serialization.Contextual
import java.time.LocalDateTime
import java.util.UUID


@kotlinx.serialization.Serializable
data class UserProfile(
    val _id:String=UUID.randomUUID().toString(),
    val firstName:String?,
    val lastName: String?,
    val email:String?,
    val phone:String?,
    // val createdAt: @Contextual LocalDateTime?=LocalDateTime.now(),
    // val lastModifiedAt: @Contextual LocalDateTime?=LocalDateTime.now()
)

@kotlinx.serialization.Serializable
data class UserProfileUpdate(
    val firstName:String?=null,
    val lastName:String?=null,
    val phone:String?=null
)
