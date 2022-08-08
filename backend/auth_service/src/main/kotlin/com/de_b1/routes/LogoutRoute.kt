package com.de_b1.routes

import com.de_b1.models.CustomResponse
import com.de_b1.service.LogoutService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
@Resource("logout")
class LogoutRoute(val parent: BaseRoute= BaseRoute())

fun Route.configureLogoutRoute(){
    val logoutService:LogoutService = LogoutService()
    authenticate {
        post<LogoutRoute>{
            try {
                val principal = call.principal<JWTPrincipal>()
                val userId = principal!!.payload.getClaim("user_id").asString()
                logoutService.logoutUser(userId)
                call.respond(message = CustomResponse(body = "Logout Successful",status = true), status = HttpStatusCode.OK)
            }
            catch (cause : Throwable)
            {
                println("catch")
                call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
                call.application.environment.log.error(cause.localizedMessage)
                call.application.environment.log.error(cause.stackTrace.toString())
            }
        }
    }
}