package com.de_b1.utils

object OTPManager {
    fun generateOTP(): String {
        val randomPin = (Math.random() * 900000).toInt() + 100000
        return randomPin.toString()
    }
}