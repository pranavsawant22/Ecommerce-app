package com.de_b1.models.schema

import org.bson.codecs.pojo.annotations.BsonId
import org.litote.kmongo.second
import java.time.LocalDateTime
import java.util.*

data class RandomToken (
    var _id: String = UUID.randomUUID().toString(),
    val email:String,
    var randomToken: String = UUID.randomUUID().toString(),
    var expireTime: LocalDateTime = LocalDateTime.now().plusMinutes(10)
        )