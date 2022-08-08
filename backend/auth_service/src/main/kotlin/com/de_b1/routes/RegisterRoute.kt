package com.de_b1.routes

import com.de_b1.models.CustomResponse
import com.de_b1.models.dto.RegisterDTO
import com.de_b1.service.RegisterService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import org.mindrot.jbcrypt.BCrypt


@Serializable
@Resource("register")
class RegisterRoute(val parent: BaseRoute = BaseRoute())

fun Route.configureRegisterRoute() {
    // register service object intialization
    val registerService = RegisterService()
        post<RegisterRoute> {
            try {
                val registerDTO = call.receive<RegisterDTO>()
                val randomTokenStringFromHeader = call.request.headers["randomToken"].toString()

                if(randomTokenStringFromHeader == "null") {
                    call.respond(message = CustomResponse(body = "No random token was sent",status = false), status = HttpStatusCode.Unauthorized)
                    throw Exception()
                }

                registerDTO.password = BCrypt.hashpw(registerDTO.password, BCrypt.gensalt())
                registerDTO.randomTokenString = randomTokenStringFromHeader
//                call.application.environment.log.info(registerDTO.toString())

                val applicationResponse = registerService.registerUser(registerDTO)
                call.respond(message = applicationResponse.message, status = applicationResponse.statusCode)

            } catch (cause: Throwable) {
                println("catch")
                call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
                call.application.environment.log.error(cause.localizedMessage)
                call.application.environment.log.error(cause.stackTrace.toString())
            }
        }
}