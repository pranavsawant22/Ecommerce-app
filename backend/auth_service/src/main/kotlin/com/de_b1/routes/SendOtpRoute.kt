package com.de_b1.routes

import com.de_b1.models.dto.SendOtpDTO
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
@Resource("send-otp")
class SendOTP (val parent: BaseRoute =  BaseRoute())

fun Route.configureSendOtp() {
    //service object intialization
    val otpService = OtpService()
    post<SendOTP> {
        try {
            val sendOtpDTO = call.receive<SendOtpDTO>()

            //call otp service
            otpService.sendOtp(sendOtpDTO.email)
            call.respond(message = "OTP sent", status = HttpStatusCode.OK)

        } catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }


}