package com.de_b1.plugins

import com.de_b1.models.CartItem
import com.de_b1.models.CartItemDelete
import com.de_b1.models.CartQty
import com.de_b1.service.CartService
import com.de_b1.utils.FailureExceptions
import com.de_b1.utils.ResponseFailure
import com.de_b1.utils.ResponseSucess
import io.ktor.server.routing.*
import io.ktor.http.*
import io.ktor.server.locations.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.request.*


fun Application.configureRouting() {

    install(Locations) {
    }

    install(StatusPages) {
        exception<AuthenticationException> { call, cause ->
            call.respond(HttpStatusCode.Unauthorized)
        }
        exception<AuthorizationException> { call, cause ->
            call.respond(HttpStatusCode.Forbidden)
        }

    }

    routing {
        get("/api/v1/cart") {

            val userId:String? = call.request.headers["user_id"]

            val cartService= CartService()

            try {
                val data=cartService.getCartData(userId)
                call.respond(
                    status = HttpStatusCode.OK,
                    message = ResponseSucess(data=data, success = true)
                )

            }

            catch (e: FailureExceptions){
                call.respond(
                    status = e.statuscode,
                    message =ResponseFailure(data=e.msg, success=false)
                )

            }


        }

        post("/api/v1/add-cart-item"){



            val userId:String? = call.request.headers["user_id"]

            val cartData= call.receive<CartItem>()

            try {

                val cartService= CartService()


                val data=cartService.addCartData(userId,cartData)
                call.respond(
                    status = HttpStatusCode.OK,
                    message = ResponseSucess( data=data, success = true)
                )

            }

            catch (e: FailureExceptions){
                call.respond(
                    status = e.statuscode,
                    message = ResponseFailure(data=e.msg, success = false)
                )

            }

        }

        patch("/api/v1/update-cart-item") {

            val userId:String? = call.request.headers["user_id"]

            var request =call.receive<CartQty>()

            val cartService= CartService()

            try {
                val data=cartService.updateCartData(userId,request.sku_id,request.quantity)
                call.respond(
                    status = HttpStatusCode.OK,
                    message = ResponseSucess(data=data,success=true)
                )

            }

            catch (e: FailureExceptions){
                call.respond(
                    status = e.statuscode,
                    message = ResponseFailure(data=e.msg,success=false)
                )

            }

        }

        delete("/api/v1/delete-cart-item"){
            val userId:String? = call.request.headers["user_id"]

            var request =call.receive<CartItemDelete>()

            val cartService= CartService()

            try {
                val data=cartService.deleteCartItem(userId,request.sku_id)
                call.respond(
                    status = HttpStatusCode.OK,
                    message = ResponseSucess(data=data,success = true)
                )

            }

            catch (e: FailureExceptions){
                call.respond(
                    status = e.statuscode,
                    message = ResponseFailure(data=e.msg,success = false)
                )

            }
        }

        delete("/api/v1/delete-all-cart-item") {
            //user id is decoded from token. for now it is hardcoded here
            val userId:String? = call.request.headers["user_id"]
            val cartService= CartService()

            try {
                val data=cartService.deleteAllCart(userId)
                call.respond(
                    status = HttpStatusCode.OK,
                    message = ResponseSucess(data=data,success = true)
                )

            }

            catch (e: FailureExceptions){
                call.respond(
                    status = e.statuscode,
                    message = ResponseFailure(data=e.msg,success = e.extra_msg?:false)
                )

            }
        }




//        get<MyLocation> {
//                call.respondText("Location: name=${it.name}, arg1=${it.arg1}, arg2=${it.arg2}")
//            }
//            // Register nested routes
//            get<Type.Edit> {
//                call.respondText("Inside $it")
//            }
//            get<Type.List> {
//                call.respondText("Inside $it")
//            }
//        // Static plugin. Try to access `/static/index.html`
//        static("/static") {
//            resources("static")
//        }
    }
}



@Location("/location/{name}")
class MyLocation(val name: String, val arg1: Int = 42, val arg2: String = "default")
@Location("/type/{name}") data class Type(val name: String) {
    @Location("/edit")
    data class Edit(val type: Type)

    @Location("/list/{page}")
    data class List(val type: Type, val page: Int)
}
class AuthenticationException : RuntimeException()
class AuthorizationException : RuntimeException()