package com.de_b1.service
import com.de_b1.models.UserProfile

import com.de_b1.models.UserProfileUpdate
import com.de_b1.repositories.UserProfileRepository
import com.de_b1.utils.FailureExceptions
import io.ktor.http.*
import java.io.*;
import java.util.regex.*;

class UserProfileService {

    suspend fun getUserProfile(userId:String?): UserProfile{

        if (userId==null){
            throw FailureExceptions(msg = "UserId is required", status = HttpStatusCode.BadRequest)
        }


        return UserProfileRepository.findUserProfile(userId=userId)?:throw FailureExceptions(msg = "No Data", status = HttpStatusCode.NotFound)


    }

    suspend fun addUserProfile(userProfileData:UserProfile):String{


        if (userProfileData.firstName==null){
            throw FailureExceptions(msg = "firstName is required", status = HttpStatusCode.BadRequest)
        }

        if (userProfileData.lastName==null){
            throw FailureExceptions(msg = "lastName is required", status = HttpStatusCode.BadRequest)
        }

        if (userProfileData.email==null){
            throw FailureExceptions(msg = "email is required", status = HttpStatusCode.BadRequest)
        }

        if (userProfileData.phone==null){
            throw FailureExceptions(msg = "phone is required", status = HttpStatusCode.BadRequest)
        }

       return UserProfileRepository.addUserProfile(userProfileData)?: throw FailureExceptions(msg = "Something went wrong", status = HttpStatusCode.InternalServerError)



    }

    suspend fun updateUserProfile(userId: String?,userProfileData:UserProfileUpdate): UserProfile {
        if (userId==null){
            throw FailureExceptions(msg = "UserId is required", status = HttpStatusCode.BadRequest)
        }


        //accept only valid parameters to update
        if ( userProfileData.firstName?.isNotBlank() == true ||  userProfileData.lastName?.isNotBlank() == true ||  userProfileData.phone?.isNotBlank() == true ){

            return UserProfileRepository.updateUserProfile(userId=userId,userProfileData=userProfileData)?:throw FailureExceptions(msg = "No Data", status = HttpStatusCode.NotFound)

        }
        else{
            throw FailureExceptions(msg = "Invalid Parameters", status = HttpStatusCode.BadRequest)
        }





    }
}