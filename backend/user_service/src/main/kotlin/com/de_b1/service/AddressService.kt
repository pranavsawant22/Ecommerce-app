package com.de_b1.service

import com.de_b1.models.Address
import com.de_b1.models.AddressRequest
import com.de_b1.models.Addresses
import com.de_b1.models.AddressWithSerialId
import com.de_b1.models.AddressesWithSerialId
import com.de_b1.repositories.AddressRepository
import com.de_b1.utils.FailureExceptions
import com.de_b1.utils.InputValidator
import com.mongodb.client.result.UpdateResult
import io.ktor.http.*

class AddressService {
    private val inputValidator : InputValidator = InputValidator()

    suspend fun addUserAddress(userId : String? , userAddress : AddressRequest): AddressesWithSerialId {
        // validate userId
        inputValidator.validateUserId(userId)

        // validate address
        inputValidator.validateUserAddress(userAddress)

        // check if user exist in addresses table
        val doc : Addresses? = AddressRepository.checkUserInAddresses(userId!!)

        // if not insert in address table
        if(doc == null) {
            AddressRepository.insertUserInAddresses(userId!!)
        }

        // add address in db
        val updateResult : UpdateResult = AddressRepository.insertUserAddressInAddresses(
            userId, Address(
                name = userAddress.name ,
                buildingInfo = userAddress.buildingInfo ,
                state = userAddress.state ,
                city = userAddress.city ,
                landmark = userAddress.landmark ,
                pincode = userAddress.pincode
            )
        )

        if(!updateResult.wasAcknowledged()){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "unable to add address")
        }

        val res : Addresses? = AddressRepository.checkUserInAddresses(userId)

        if(res == null){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "db error, inserted id = ${updateResult.upsertedId}")
        }

        val resWithSerialId = AddressesWithSerialId(_id = res._id , userId = res.userId , addresses = arrayListOf())

        for((index,ad) in res.addresses.withIndex()){
            resWithSerialId.addresses.add(
                AddressWithSerialId(
                    _id = ad._id ,
                    serialId = index ,
                    name = ad.name,
                    buildingInfo = ad.buildingInfo,
                    state = ad.state ,
                    city = ad.city ,
                    landmark = ad.landmark,
                    pincode = ad.pincode
                )
            )
        }

        return resWithSerialId
    }

    suspend fun updateUserAddress(userId : String? , addressId : String? ,userAddress : AddressRequest) : AddressesWithSerialId {
        // validate userId
        inputValidator.validateUserId(userId)

        // validate addressId
        inputValidator.validateAddressId(addressId)

        // validate address
        inputValidator.validateUserAddress(userAddress)

        // check if user exist in addresses table
        val doc : Addresses? = AddressRepository.checkUserInAddresses(userId!!)

        if(doc == null){
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "no user found with userId $userId")
        }

        // update address
        val oldAddressRemoved : UpdateResult =  AddressRepository.removeUserAddressInAddresses(userId!!,addressId!!)

        println("oldAddressRemoved: $oldAddressRemoved")

        if(!oldAddressRemoved.wasAcknowledged()){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "address with addressId $addressId was not updated")
        }

        if(oldAddressRemoved.modifiedCount < 1){
            throw FailureExceptions(status = HttpStatusCode.Unauthorized,msg = "address with addressId $addressId does not belong to user with userId $userId")
        }

        val updateResult : UpdateResult = AddressRepository.insertUserAddressInAddresses(
            userId!!, Address(
                name = userAddress.name ,
                buildingInfo = userAddress.buildingInfo ,
                state = userAddress.state ,
                city = userAddress.city ,
                landmark = userAddress.landmark ,
                pincode = userAddress.pincode
            )
        )

        if(!updateResult.wasAcknowledged()){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "address with addressId $addressId was not updated")
        }

        val res : Addresses? = AddressRepository.checkUserInAddresses(userId!!)

        if(res == null){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "db error, inserted id = ${updateResult.upsertedId}")
        }

        val resWithSerialId = AddressesWithSerialId(_id = res._id , userId = res.userId , addresses = arrayListOf())

        for((index,ad) in res.addresses.withIndex()){
            resWithSerialId.addresses.add(
                AddressWithSerialId(
                    _id = ad._id ,
                    serialId = index ,
                    name = ad.name,
                    buildingInfo = ad.buildingInfo,
                    state = ad.state ,
                    city = ad.city ,
                    landmark = ad.landmark,
                    pincode = ad.pincode
                )
            )
        }

        return resWithSerialId
    }

//Get all Address
    suspend fun getUserAddress(userId: String?): AddressesWithSerialId {
        inputValidator.validateUserId(userId)
        val doc : Addresses? = AddressRepository.checkUserInAddresses(userId!!)
        if(doc == null) {
            AddressRepository.insertUserInAddresses(userId!!)
        }

        val res : Addresses? = AddressRepository.checkUserInAddresses(userId!!)
        if(res == null){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "server error")
        }

        val resWithSerialId = AddressesWithSerialId(_id = res._id , userId = res.userId , addresses = arrayListOf())

        for((index,ad) in res.addresses.withIndex()){
            resWithSerialId.addresses.add(
                AddressWithSerialId(
                    _id = ad._id ,
                    serialId = index ,
                    name = ad.name,
                    buildingInfo = ad.buildingInfo,
                    state = ad.state ,
                    city = ad.city ,
                    landmark = ad.landmark,
                    pincode = ad.pincode
                )
            )
        }

        return resWithSerialId
    }


    //Delete address by addressId
    suspend fun deleteUserAddress(userId: String? , addressId: String?) : AddressesWithSerialId {

        // validate userId
        inputValidator.validateUserId(userId)

        // validate addressId
        inputValidator.validateAddressId(addressId)

        val doc : Addresses? = AddressRepository.checkUserInAddresses(userId!!)
        if(doc == null) {
            throw FailureExceptions(status = HttpStatusCode.BadRequest,msg = "no user found with userId $userId")
        }


        val deleteAddressId = AddressRepository.removeUserAddressInAddresses(userId,addressId!!)

        if(!deleteAddressId.wasAcknowledged()){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "address with addressId $addressId was not updated")
        }

        val res : Addresses? = AddressRepository.checkUserInAddresses(userId!!)

        if(res == null){
            throw FailureExceptions(status = HttpStatusCode.InternalServerError,msg = "db error, inserted id = ${deleteAddressId.upsertedId}")
        }

        val resWithSerialId = AddressesWithSerialId(_id = res._id , userId = res.userId , addresses = arrayListOf())

        for((index,ad) in res.addresses.withIndex()){
            resWithSerialId.addresses.add(
                AddressWithSerialId(
                    _id = ad._id ,
                    serialId = index ,
                    name = ad.name,
                    buildingInfo = ad.buildingInfo,
                    state = ad.state ,
                    city = ad.city ,
                    landmark = ad.landmark,
                    pincode = ad.pincode
                )
            )
        }

        return resWithSerialId

    }



}