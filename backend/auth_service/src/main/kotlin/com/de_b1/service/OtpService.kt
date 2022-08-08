package com.de_b1.service

import com.de_b1.models.ApplicationResponses
import com.de_b1.models.CustomResponse
import com.de_b1.models.schema.OTP
import com.de_b1.models.schema.RandomToken
import com.de_b1.repositories.OTPRespository
import com.de_b1.repositories.RandomTokenRepository
import io.ktor.http.*
import java.time.LocalDateTime

class OtpService {

    suspend fun sendOtp (email: String) {

        val otp = OTP(
            email = email,
            otp = "123456"
        )
        //send otp to user

        // save in db
        val otpInDB: OTP? = OTPRespository.findOTPByEmail(email)
        if (otpInDB != null) {
            otp._id = otpInDB._id
        }
        OTPRespository.saveOTP(otp)
    }

    suspend fun validateOtp (email: String, otp: String): ApplicationResponses {

        val otpFromDB = OTPRespository.findOTPByEmail(email)
        println(otpFromDB.toString())
        if (otpFromDB == null) {
            return ApplicationResponses(
                CustomResponse(body = "Invalid Email",status = false),
                statusCode = HttpStatusCode.Conflict
            )
        }
        else if (otpFromDB.expireTime <= LocalDateTime.now()) {
            return ApplicationResponses(
                CustomResponse(body = "OTP expired",status = false),
                statusCode = HttpStatusCode.Conflict
            )
        }
        else if (otpFromDB.otp.toString() != otp ) {
            return ApplicationResponses(
                CustomResponse(body = "Invalid OTP",status = false),
                statusCode = HttpStatusCode.Conflict
            )
        }
        val randomToken = RandomToken(
            email = email
        )

        val randomTokenInDB: RandomToken? = RandomTokenRepository.findRandomTokenByEmail(email)
        if (randomTokenInDB != null) {
            randomToken._id = randomTokenInDB._id
        }
        RandomTokenRepository.saveRandomToken(randomToken)

        return ApplicationResponses(
            CustomResponse(body = randomToken.randomToken,status = true),
            statusCode = HttpStatusCode.OK
        )

    }
}