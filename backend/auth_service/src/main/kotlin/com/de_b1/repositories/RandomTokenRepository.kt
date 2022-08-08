package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.schema.RandomToken
import com.mongodb.client.result.DeleteResult
import com.mongodb.client.result.UpdateResult
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq
import org.litote.kmongo.set
import org.litote.kmongo.setTo

object RandomTokenRepository {
    private val randomTokenCollection: CoroutineCollection<RandomToken> = MongoConfig.getDatabase().getCollection()

    suspend fun saveRandomToken(randomToken: RandomToken) {
        randomTokenCollection.save(randomToken)
    }

    suspend fun getAllRandomToken(): List<RandomToken>? {
        return randomTokenCollection.find().toList()
    }

    suspend fun findRandomTokenByEmail(email:String): RandomToken? {
        return randomTokenCollection.findOne(RandomToken::email eq email)
    }

    suspend fun updateRandomTokenByEmail(newRandomToken:RandomToken): UpdateResult {
        return randomTokenCollection.updateOne(RandomToken::email eq newRandomToken.email,
            set(RandomToken::randomToken setTo newRandomToken.randomToken, RandomToken::expireTime setTo newRandomToken.expireTime))
    }

    suspend fun deleteRandomTokenByEmail(email:String): DeleteResult {
        return randomTokenCollection.deleteMany(RandomToken:: email eq email)
    }

}