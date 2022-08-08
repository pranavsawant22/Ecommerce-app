package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.schema.OTP
import com.mongodb.client.result.DeleteResult
import com.mongodb.client.result.UpdateResult
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq
import org.litote.kmongo.set
import org.litote.kmongo.setTo

object OTPRespository {
    private var otpCollection: CoroutineCollection<OTP> = MongoConfig.getDatabase().getCollection()

    suspend fun saveOTP(otp:OTP) {
        otpCollection.save(otp)
    }

    suspend fun getAllOTP():List<OTP>?{
        return otpCollection.find().toList()
    }

    suspend fun findOTPByEmail(email: String): OTP?{
        return otpCollection.findOne(OTP::email eq email)
    }

    suspend fun updateOTPByEmail(newOTP:OTP): UpdateResult {
        return otpCollection.updateOne(OTP::email eq newOTP.email,
                                    set(OTP::otp setTo newOTP.otp, OTP::expireTime setTo newOTP.expireTime))
    }

    suspend fun deleteOTPByEmail(email:String): DeleteResult{
        return otpCollection.deleteOne(OTP::email eq email)
    }

}