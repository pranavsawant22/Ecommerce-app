package com.de_b1.routes

import com.de_b1.models.dto.ChangePasswordDTO
import com.de_b1.service.PasswordService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
@Resource("change-password")
class ChangePasswordRoute(val parent: BaseRoute= BaseRoute())

fun Route.configureChangePasswordRoute(){
    val passwordService:PasswordService= PasswordService()
    authenticate {
        post<ChangePasswordRoute>{
            try {
                call.application.log.info("ChangePasswordRoute called")
                val principal = call.principal<JWTPrincipal>()
                var userId = principal!!.payload.getClaim("user_id").asString()
                val changePasswordDTO = call.receive<ChangePasswordDTO>()
                val applicationResponse = passwordService.changePassword(userId = userId,changePasswordDTO)
                call.respond(message = applicationResponse.message, status = applicationResponse.statusCode)
            }
            catch (cause : Throwable)
            {
                call.application.log.info("catch")
                call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
                call.application.environment.log.error(cause.localizedMessage)
                call.application.environment.log.error(cause.stackTrace.toString())
            }
        }
    }
}