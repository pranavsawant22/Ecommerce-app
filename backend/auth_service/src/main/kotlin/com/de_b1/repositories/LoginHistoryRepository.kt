package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.schema.LoginHistory
import com.mongodb.client.result.DeleteResult
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq

object LoginHistoryRepository {
    private val loginHistoryCollection: CoroutineCollection<LoginHistory> = MongoConfig.getDatabase().getCollection()

    suspend fun saveLoginHistory(loginHistory: LoginHistory) {
        print(loginHistory.toString())
        loginHistoryCollection.save(loginHistory)
    }


    suspend fun findLoginHistoryByUserId(userId:String): List<LoginHistory>?{
        return loginHistoryCollection.find(LoginHistory::userId eq userId).toList()
    }

    suspend fun findLoginHistoryByLoginId(loginId:String): LoginHistory? {
        return loginHistoryCollection.findOneById(loginId)
    }

    suspend fun deleteLoginHistoryByLoginId(loginId:String): DeleteResult {
        return loginHistoryCollection.deleteOneById(loginId)
    }

    suspend fun deleteLoginHistoryByuserId(userId:String): DeleteResult {
        return loginHistoryCollection.deleteMany(LoginHistory:: userId eq userId)
    }
}