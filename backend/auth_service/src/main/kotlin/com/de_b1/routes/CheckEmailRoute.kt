package com.de_b1.routes

import com.de_b1.models.dto.CheckEmailDTO
import com.de_b1.service.CheckEmailService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
@Resource("/check-email")
class CheckEmail(val parent: BaseRoute = BaseRoute())

fun Route.configureCheckEmailRoute(){

    get<CheckEmail> {
        try {
            val checkEmailDTO: CheckEmailDTO = CheckEmailDTO(call.request.headers["email"].toString())
            println(checkEmailDTO.toString())
            if(checkEmailDTO.email == "null")
            {
                throw UnsafeHeaderException("Email not in Header")
            }
            val checkEmailService = CheckEmailService()
            val applicationResponse = checkEmailService.checkEmailService(checkEmailDTO.email)

            call.respond(applicationResponse.statusCode, applicationResponse.message)
        }
        catch (cause: Throwable) {
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
        }
    }

}