package com.de_b1.routes

import com.de_b1.models.dto.ValidateOtpDTO
import com.de_b1.service.OtpService
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
@Resource("validate-otp")
class ValidateOTP (val parent: BaseRoute =  BaseRoute())

fun Route.configureValidateOtp() {

    val otpService = OtpService()
    post<ValidateOTP> {
        try {
            val sendOtpDTO = call.receive<ValidateOtpDTO>()
            println(sendOtpDTO.toString())
            //call otp service
            let {  }
            val applicationResponse = otpService.validateOtp(sendOtpDTO.email, sendOtpDTO.otp)
            call.respond(message = applicationResponse.message, status = applicationResponse.statusCode)

        } catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }

}