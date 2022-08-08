package com.de_b1.utils

import com.de_b1.models.AddressRequest
import io.ktor.http.*

class InputValidator {
    suspend fun validateUserId(userId : String?){
        if(userId == null){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "user id is missing")
        }

        if(userId == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "user id is empty")
        }
    }

    suspend fun validateAddressId(addressId : String?){
        if(addressId == null){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "address id is missing")
        }

        if(addressId == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "address id is empty")
        }
    }

    suspend fun validateUserAddress(userAddress : AddressRequest){
        if(userAddress.name == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "name is missing")
        }
        if(userAddress.buildingInfo == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "building info is missing")
        }
        if(userAddress.city == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "city is missing")
        }
        if(userAddress.landmark == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "landmark is missing")
        }
        if(userAddress.state == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "state is missing")
        }
        if(userAddress.pincode == ""){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "pincode is missing")
        }
    }
}