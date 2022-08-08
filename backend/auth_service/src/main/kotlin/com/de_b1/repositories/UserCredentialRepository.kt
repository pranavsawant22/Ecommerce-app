package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.schema.OTP
import com.de_b1.models.schema.UserCredentials
import com.mongodb.client.result.DeleteResult
import com.mongodb.client.result.UpdateResult
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq
import org.litote.kmongo.set
import org.litote.kmongo.setTo

object UserCredentialRepository {

    private var userCredentialsCollection: CoroutineCollection<UserCredentials> = MongoConfig.getDatabase().getCollection()

    suspend fun findUserCredentialById(id:String):UserCredentials?{
        return userCredentialsCollection.findOneById(id)
    }

    suspend fun findUserCredentialByEmail(email: String):UserCredentials?{
        return userCredentialsCollection.findOne(UserCredentials::email eq email)
    }
    suspend fun findUserCredentialByUserId(userId: String):UserCredentials?{
        return userCredentialsCollection.findOne(UserCredentials::userId eq userId)
    }

    suspend fun findUserCredentialByAccessToken(jwtAccessToken:String):UserCredentials?{
        return userCredentialsCollection.findOne(UserCredentials::jwtAccessToken eq jwtAccessToken)
    }

   suspend fun deleteUserCredentialById(userId:String): DeleteResult {
        return userCredentialsCollection.deleteOne(UserCredentials::_id eq userId)
   }

    suspend fun updateUserCredential(userCredentials: UserCredentials): UpdateResult {
        return userCredentialsCollection.updateOne(userCredentials._id,userCredentials)
    }
    suspend fun updateLoginStatusByUserId(status: Boolean,userId:String): UpdateResult {
        return userCredentialsCollection.updateOne(
            "{userId:$userId}", "{\$set:{isLoggedIn:$status}}"
        )
    }

    suspend fun updatePasswordHashByUserId(passwordHash:String,userId:String): UpdateResult {
        println(passwordHash)
        return userCredentialsCollection.updateOne(
            "{userId:$userId}", "{\$set:{passwordHash:${passwordHash}}}"
        )
    }

    suspend fun deleteSessionCredentialsByUserId(userId:String): UpdateResult {
        return userCredentialsCollection.updateOne(
            UserCredentials::userId eq userId,set(UserCredentials::jwtAccessToken setTo null, UserCredentials::isLoggedIn setTo false)
        )
    }

    suspend fun updateJWTTokenByUserId(jwtAceessToken: String,userId:String): UpdateResult {
        return userCredentialsCollection.updateOne(
            UserCredentials::userId eq userId,
            set(UserCredentials::jwtAccessToken setTo jwtAceessToken)
        )
    }

    suspend fun saveUserCredential(userCredentials:UserCredentials) {
        userCredentialsCollection.save(userCredentials)
    }

}