package com.de_b1.repositories


import com.de_b1.config.MongoConfig
import com.de_b1.models.Cart
import com.de_b1.models.CartItem
import com.de_b1.utils.FailureExceptions
import io.ktor.http.*
import org.litote.kmongo.MongoOperator.*
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.eq


object CartRepository {
    private val cartCollection: CoroutineCollection<Cart> = MongoConfig.getDatabase().getCollection()

    //working
    suspend fun findCartByUserId(userId:String?):Cart? {
        return cartCollection.findOne(Cart::user_id eq userId)
    }

    //working but storing string in db instead of object.

    suspend fun addToCartWhenCartNotExists(userId: String?,cartData:Cart):Cart?{
            cartCollection.insertOne(cartData)
            return cartCollection.findOne(Cart::user_id eq userId);

    }
    suspend fun addToCartWhenCartExists(userId: String?,cartItem:CartItem):Cart?{
        cartCollection.updateOne("{user_id:'$userId'}","{$push:{'cart_items':{'cart_item_id':'${cartItem.cart_item_id}','sku_id':'${cartItem.sku_id}','quantity':'${cartItem.quantity}'}}}")
        return cartCollection.findOne(Cart::user_id eq userId);
    }



    suspend fun updateQuantityByUserId(userId: String?,sku_id: String,quantity:Int):Cart?{
        cartCollection.findOneAndUpdate("{user_id:'$userId','cart_items.sku_id':'$sku_id'}","{$set:{'cart_items.$.quantity':'$quantity'}}")
        return cartCollection.findOne(Cart::user_id eq userId);


    }

    suspend fun deleteCartItem(userId: String,sku_id:String):Cart?{
        cartCollection.findOneAndUpdate("{user_id:'$userId'}","{$pull:{'cart_items':{'sku_id':'$sku_id'}}}")
        return cartCollection.findOne(Cart::user_id eq userId);
    }

    //working
    suspend fun deleteCart(userId: String):Cart?{
        cartCollection.findOneAndDelete("{user_id:'$userId'}")
        return cartCollection.findOne(Cart::user_id eq userId);
    }
}

//return cartCollection.updateOne("{user_id:'$userId'}","{$push:{cart_items:'$cartItem'}}")

//inserting object
//return cartCollection.updateOne("{user_id:'$userId'}","{$push:{'cart_items':{'name':'bhanu'}}}")