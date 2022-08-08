package com.de_b1.routes

import com.de_b1.models.CustomResponse
import com.de_b1.models.dto.UserLoginDTO
import com.de_b1.models.schema.TypeOfLogin
import com.de_b1.service.LoginService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable


@Serializable
@Resource("login")
class Login(val parent: BaseRoute = BaseRoute())

fun Route.configureLoginRoute() {
    val loginService: LoginService = LoginService()
    post<Login> {
        try {
            val loginDTO = call.receive<UserLoginDTO>()
            var typeOfLoginHeader = call.request.headers["typeOfLogin"].toString()
            var clientHeader = call.request.headers["client"].toString()
            if (typeOfLoginHeader == "null") {
                call.respond(message = CustomResponse(body = "No typeOfLogin provided",status = false), status = HttpStatusCode.BadRequest)
                throw Exception()
            }
            loginDTO.typeOfLogin = enumValueOf<TypeOfLogin>(typeOfLoginHeader)
            loginDTO.client = clientHeader
            call.application.environment.log.info(loginDTO.toString())

            val applicationResponse = loginService.loginUser(loginDTO)

            call.respond(message = applicationResponse.message, status = applicationResponse.statusCode)
        } catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }

    }
}