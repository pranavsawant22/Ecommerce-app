@file:Suppress("UNUSED_EXPRESSION")

package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.UserProfile
import com.de_b1.models.UserProfileUpdate
import com.mongodb.client.model.UpdateOptions
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq
import org.litote.kmongo.MongoOperator.*
import org.litote.kmongo.coroutine.insertOne
import org.litote.kmongo.upsert
import java.util.Date

object UserProfileRepository {
    private val UserProfileCollection: CoroutineCollection<UserProfile> = MongoConfig.getDatabase().getCollection()

    suspend fun findUserProfile(userId:String?):UserProfile? {
        return UserProfileCollection.findOne(UserProfile::_id eq userId)
    }

    suspend fun addUserProfile(userProfileData:UserProfile):String?{

        val userDataToInsert=UserProfile(firstName =userProfileData.firstName, lastName =userProfileData.lastName, email = userProfileData.email, phone = userProfileData.phone)
        val _id=userDataToInsert._id
        UserProfileCollection.insertOne(userDataToInsert)
        return _id



    }

    suspend fun updateUserProfile(userId: String?,userProfileData:UserProfileUpdate):UserProfile?{

        """
        For updating the user can update any field out of firstName, lastName or phone
        So first we are fetching the existingUserData and by seeing which field the user has given to update that we are updating rest will remain the same
        The unchanged fields(fields for which user did not send data) need to remain same for that we are using the existing data 
        """


        val existingUserData =UserProfileCollection.findOne(UserProfile::_id eq userId)
        UserProfileCollection.updateOne("{_id:'$userId'}","{$set:{firstName:'${userProfileData.firstName?:existingUserData?.firstName}',lastName:'${userProfileData.lastName?:existingUserData?.lastName}',phone:'${userProfileData.phone?:existingUserData?.phone}'}}")

        // UserProfileCollection.updateOne("{_id:'$userId'}","{$currentDate:{lastModifiedAt:true}}")

        return UserProfileCollection.findOne(UserProfile::_id eq userId)
    }

}
