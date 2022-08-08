package com.de_b1.plugins

import com.de_b1.models.AddressRequest
import com.de_b1.models.Addresses
import com.de_b1.models.UserProfile
import com.de_b1.models.UserProfileUpdate
import com.de_b1.service.AddressService
import com.de_b1.service.UserProfileService
import com.de_b1.utils.FailureExceptions
import com.de_b1.utils.ResponseFailure
import com.de_b1.utils.ResponseSuccess
import io.ktor.server.routing.*
import io.ktor.http.*
import io.ktor.server.locations.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.response.*
import io.ktor.server.request.*
import io.ktor.serialization.kotlinx.json.*

fun Application.configureRouting() {
//    install(Locations) {
//    }
    
//    install(StatusPages) {
//        exception<AuthenticationException> { call, cause ->
//            call.respond(HttpStatusCode.Unauthorized)
//        }
//        exception<AuthorizationException> { call, cause ->
//            call.respond(HttpStatusCode.Forbidden)
//        }
//
//    }

//    install(ContentNegotiation){
//        json()
//    }

    routing {
        get("/") {
            call.respondText("Hello World!")
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

        get("/api/v1/user/profile"){

            val userId:String? = call.request.headers["user_id"]

            val userProfileService= UserProfileService()
            try {
                call.respond(
                    status = HttpStatusCode.OK,
                    message =userProfileService.getUserProfile(userId=userId)
                )
            }catch (e: FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message
                ),)
            }

        }

        post("/api/v1/user/profile"){


            val request =call.receive<UserProfile>()

            val userProfileService= UserProfileService()
            try {
                call.respond(
                    status = HttpStatusCode.OK,
                    message =userProfileService.addUserProfile(userProfileData = request)
                )
            }catch (e: FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message))
            }

        }



        patch("/api/v1/user/profile"){

            val userId:String? = call.request.headers["user_id"]

            val request =call.receive<UserProfileUpdate>()


            val userProfileService= UserProfileService()
            try {
                call.respond(
                    status = HttpStatusCode.OK,
                    message =userProfileService.updateUserProfile(userId=userId, userProfileData = request)
                )
            }catch (e: FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message
                ),)
            }

        }
//        get all addresses of user
        get("/api/v1/user/address"){
            val userId:String? = call.request.headers["user_id"]
            try {
                call.respond(
                    status = HttpStatusCode.OK,
                    message = ResponseSuccess(
                        success = true,
                        addresses = AddressService().getUserAddress(userId = userId)
                    )
                )
            }catch (e: FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message
                ),)
            }
        }

//        add one address of user
        post("/api/v1/user/address"){
            val userAddress : AddressRequest = call.receive<AddressRequest>()
            val userId : String? = call.request.headers["user_id"]
            try{
                call.respond(
                    status = HttpStatusCode.Created ,
                    message = ResponseSuccess(
                        success = true ,
                        addresses = AddressService().addUserAddress(userId = userId , userAddress = userAddress)
                    )
                )
            }catch (e : FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message
                ),)
            }
        }

//        update one address of user
        put("/api/v1/user/address/{address_id}"){
            val userId : String? = call.request.headers["user_id"]
            val addressId : String? = call.parameters["address_id"]
            val userAddress : AddressRequest = call.receive<AddressRequest>()

            try {
                call.respond(
                    status = HttpStatusCode.Created,
                    message = ResponseSuccess(
                        success = true ,
                        addresses = AddressService().updateUserAddress(userId = userId,addressId = addressId,userAddress = userAddress)
                    )
                )
            }catch (e : FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message
                ),)
            }
        }

//        delete one address of user
        delete("/api/v1/user/address/{address_id}"){
            val userId : String? = call.request.headers["user_id"]
            val addressId : String? = call.parameters["address_id"]
//            val userAddress : AddressRequest = call.receive<AddressRequest>()


            try {

                call.respond(
                    status = HttpStatusCode.Created,
                    message = ResponseSuccess(
                        success = true ,
                        addresses = AddressService().deleteUserAddress(userId = userId,addressId = addressId)
                    )
                )
            }catch (e : FailureExceptions){
                call.respond(status = e.status ,message = ResponseFailure(
                    success = false ,
                    message = e.message
                ),)
            }
        }

    }
}


//@Location("/location/{name}")
//class MyLocation(val name: String, val arg1: Int = 42, val arg2: String = "default")
//@Location("/type/{name}") data class Type(val name: String) {
//    @Location("/edit")
//    data class Edit(val type: Type)
//
//    @Location("/list/{page}")
//    data class List(val type: Type, val page: Int)
//}
//class AuthenticationException : RuntimeException()
//class AuthorizationException : RuntimeException()
