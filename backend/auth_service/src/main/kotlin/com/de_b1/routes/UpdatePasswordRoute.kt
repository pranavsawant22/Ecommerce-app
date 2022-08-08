package com.de_b1.routes

import com.de_b1.models.CustomResponse
import com.de_b1.models.dto.UpdatePasswordDTO
import com.de_b1.repositories.RandomTokenRepository
import com.de_b1.service.PasswordService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import java.time.LocalDateTime

@Serializable
@Resource("update-password")
class UpdatePasswordRoute(val parent: BaseRoute = BaseRoute())

suspend fun checkRandomTokenInDB(email: String, randomToken: String): Boolean {

    val randomTokenFromDB = RandomTokenRepository.findRandomTokenByEmail(email)
    println(randomTokenFromDB)
    if (randomTokenFromDB == null) {
        return false
    } else if (randomTokenFromDB.randomToken == randomToken && randomTokenFromDB.expireTime > LocalDateTime.now()) {
        return true
    }
    return false
}


fun Route.configureUpdatePasswordRoute() {
    val passwordService: PasswordService = PasswordService()
    post<UpdatePasswordRoute> {
        try {
            println("UpdatePasswordRoute called")
            val randomTokenStringFromHeader = call.request.headers["randomToken"].toString()
            val emailId = call.request.headers["email_id"].toString()

            if (randomTokenStringFromHeader == "null") {
                call.respond(message = CustomResponse(body = "No random token was sent",status = false), status = HttpStatusCode.Unauthorized)
                throw Exception()
            }
            if (!checkRandomTokenInDB(emailId, randomTokenStringFromHeader)) {
                call.respond(message = CustomResponse(body = "Random Token Not Found",status = false), status = HttpStatusCode.Conflict)
                throw Exception()
            }

            val updatePasswordDTO = call.receive<UpdatePasswordDTO>()
            val applicationResponse = passwordService.updatePassword(emailId = emailId, updatePasswordDTO)
            call.respond(message = applicationResponse.message, status = applicationResponse.statusCode)
        } catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
        }
}