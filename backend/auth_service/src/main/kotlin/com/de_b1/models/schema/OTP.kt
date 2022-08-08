package com.de_b1.models.schema

import com.de_b1.utils.OTPManager
import java.time.LocalDateTime
import java.util.UUID

data class OTP (
    var _id: String = UUID.randomUUID().toString(),
    val email:String,
    var otp: String = OTPManager.generateOTP(),
    var expireTime: LocalDateTime = LocalDateTime.now().plusMinutes(5)
)