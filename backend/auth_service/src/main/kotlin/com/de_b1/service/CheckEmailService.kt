package com.de_b1.service

import com.de_b1.models.ApplicationResponses
import com.de_b1.models.CustomResponse
import com.de_b1.models.schema.UserCredentials
import com.de_b1.repositories.UserCredentialRepository
import io.ktor.http.*

class CheckEmailService {

    suspend fun checkEmailService(email: String): ApplicationResponses {

        val userCredentials: UserCredentials? = UserCredentialRepository.findUserCredentialByEmail(email)

        if (userCredentials == null) {
            // return doesn't exist
            return ApplicationResponses(message = CustomResponse(body = "Email doesn't exist",status = false) ,statusCode = HttpStatusCode.OK)
        }
        else {
            // return user exists
            return ApplicationResponses(message = CustomResponse(body = "Email exists",status = true), statusCode = HttpStatusCode.OK)
        }
    }
}