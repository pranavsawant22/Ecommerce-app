package com.de_b1.service

import com.de_b1.models.Cart
import com.de_b1.models.CartItem
import com.de_b1.repositories.CartRepository
import com.de_b1.utils.FailureExceptions
import io.ktor.http.*
import org.litote.kmongo.eq


class CartService {

    suspend fun getCartData(userId:String?): Cart {

        //check for userId

        if (userId==null){
            throw  FailureExceptions(msg="UserId is required", statuscode = HttpStatusCode.BadRequest)

        }

        val result: Cart? = CartRepository.findCartByUserId(userId)

        if( result == null ) {
            throw FailureExceptions(msg = "No Cart Data", statuscode = HttpStatusCode.NotFound)
        }
        return result

    }

    suspend fun addCartData(userId: String?,cartItem: CartItem):Cart{

        //check for incoming parameters

        if (userId==null){
            throw  FailureExceptions(msg="UserId is required", statuscode = HttpStatusCode.BadRequest)

        }

        if (cartItem.sku_id==null){
            throw FailureExceptions(msg="sku_id missing", statuscode = HttpStatusCode.BadRequest)
        }
        if (cartItem.quantity==null){
            throw FailureExceptions(msg="quantity missing", statuscode = HttpStatusCode.BadRequest)
        }

        val result: Cart? = CartRepository.findCartByUserId(userId)

        //if user cart doesn't exist
        if( result == null ) {

            val cartList=ArrayList<CartItem>()
            cartList.add(CartItem(sku_id = cartItem.sku_id, quantity = cartItem.quantity))
            val cartData=Cart(user_id = userId, cart_items = cartList)
            return CartRepository.addToCartWhenCartNotExists(userId,cartData)?:throw  FailureExceptions(msg="No Data", statuscode = HttpStatusCode.OK)

        }

        //if user cart already exists

        else{
            val cartData = CartRepository.findCartByUserId(userId)
            cartData?.cart_items?.forEach{
                if (it.sku_id == cartItem.sku_id){
                    throw  FailureExceptions(msg="Cart Item Already Added", statuscode = HttpStatusCode.BadRequest)
                }
            }
            return CartRepository.addToCartWhenCartExists(userId,CartItem(sku_id = cartItem.sku_id, quantity = cartItem.quantity))?:throw  FailureExceptions(msg="No Data", statuscode = HttpStatusCode.OK)
        }


    }

    suspend fun updateCartData(userId: String?,skuId: String?, quantity: Int?): Cart {

        //check for incoming parameters

        if (userId==null){
            throw  FailureExceptions(msg="UserId is required", statuscode = HttpStatusCode.BadRequest)

        }

        if (skuId==null){
            throw FailureExceptions(msg="sku_id missing", statuscode = HttpStatusCode.BadRequest)
        }
        if (quantity==null){
            throw FailureExceptions(msg="quantity missing", statuscode = HttpStatusCode.BadRequest)
        }

        //find if user cart exists or not


        val cartData = CartRepository.findCartByUserId(userId)

        //if not found say Cart Doesn't exist

        if (cartData==null){
            throw  FailureExceptions(msg="Cart Doesn't exists", statuscode = HttpStatusCode.BadRequest)

        }

        //if found then check if cart item to be added is already present or not

        //if not found then update the cart_items list
        cartData?.cart_items?.forEach{
            if (it.sku_id == skuId){
                return CartRepository.updateQuantityByUserId(userId, skuId, quantity)?:throw  FailureExceptions(msg="No Data", statuscode = HttpStatusCode.OK)

            }
        }

        //if present then throw this exception

        throw  FailureExceptions(msg="Please add cartItem before trying to update", statuscode = HttpStatusCode.BadRequest)


    }

    suspend fun deleteAllCart(userId: String?):Cart{
        if (userId==null){
            throw  FailureExceptions(msg="UserId is required", statuscode = HttpStatusCode.BadRequest)

        }

        val result: Cart? = CartRepository.findCartByUserId(userId)

        if( result == null ) {
            throw FailureExceptions(msg = "Cart doesn't exists", statuscode = HttpStatusCode.BadRequest)
        }

        return CartRepository.deleteCart(userId)?:throw  FailureExceptions(msg="No Data", statuscode = HttpStatusCode.OK,extra_msg=true)


    }

    suspend fun  deleteCartItem(userId: String?,skuId: String?):Cart{


        if (userId==null){
            throw  FailureExceptions(msg="UserId is required", statuscode = HttpStatusCode.BadRequest)

        }

        if (skuId==null){
            throw  FailureExceptions(msg="SkuId is required", statuscode = HttpStatusCode.BadRequest)

        }

        val result: Cart? = CartRepository.findCartByUserId(userId)

        if( result == null ) {
            throw FailureExceptions(msg = "Cart doesn't exists", statuscode = HttpStatusCode.BadRequest)
        }

        result.cart_items.forEach{

            if (it.sku_id==skuId){
                return CartRepository.deleteCartItem(userId,skuId)?:throw  FailureExceptions(msg="No Data", statuscode = HttpStatusCode.OK)
            }
        }

        throw FailureExceptions(msg = "Add Cart Item to Delete", statuscode = HttpStatusCode.BadRequest)


    }
}