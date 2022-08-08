package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.Address
import com.de_b1.models.Addresses
import com.mongodb.client.model.FindOneAndDeleteOptions
import com.mongodb.client.result.UpdateResult
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq

object AddressRepository {
    private val AddressesCollection: CoroutineCollection<Addresses> = MongoConfig.getDatabase().getCollection()

    suspend fun checkUserInAddresses(userId : String) : Addresses? {
        return AddressesCollection.findOne(Addresses::userId eq userId)
    }

    suspend fun insertUserInAddresses(userId : String){
        AddressesCollection.insertOne(Addresses(userId = userId , addresses = arrayListOf()))
    }

    suspend fun insertUserAddressInAddresses(userId : String ,address : Address) : UpdateResult{
        val filter : String = "{userId:'$userId'}"
        val update : String = "{\$push:{addresses : {_id:'${address._id}', name:'${address.name}' ,buildingInfo:'${address.buildingInfo}',state:'${address.state}',city:'${address.city}',landmark:'${address.landmark}',pincode:'${address.pincode}' }}}"
        return AddressesCollection.updateOne(filter = filter , update = update)
    }

    suspend fun removeUserAddressInAddresses(userId : String , addressId : String) : UpdateResult{
        val filter : String = "{userId:'$userId'}"
        val update : String = "{\$pull : { addresses : { _id : '$addressId' } } }"
        return AddressesCollection.updateOne(filter = filter,update = update)
    }

}