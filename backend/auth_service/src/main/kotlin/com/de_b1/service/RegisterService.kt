package com.de_b1.service

import com.de_b1.httpClient
import com.de_b1.models.ApplicationResponses
import com.de_b1.models.CustomResponse
import com.de_b1.models.dto.RegisterDTO
import com.de_b1.models.dto.UserProfileDTO
import com.de_b1.models.schema.UserCredentials
import com.de_b1.repositories.RandomTokenRepository
import com.de_b1.repositories.UserCredentialRepository
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import java.time.LocalDateTime
import java.util.UUID

class RegisterService {

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

    suspend fun registerUser(registerDTO: RegisterDTO): ApplicationResponses {

        println("in register route")
        if (checkRandomTokenInDB(registerDTO.email, registerDTO.randomTokenString!!)) {
                //create user profile object to send user service
                val userProfileDTO = UserProfileDTO(
                    firstName = registerDTO.firstName,
                    lastName = registerDTO.lastName,
                    email = registerDTO.email,
                    phone = registerDTO.phone
                )

                //redirect call to user service for storing user details
                // TO DO: change the URL
                val response = httpClient.post("https://user-service-capstone.herokuapp.com/api/v1/user/profile") {
                    contentType(ContentType.Application.Json)
                    setBody(userProfileDTO)
                }

                val userServiceResponse: String = response.body<String>().toString()
                println(userServiceResponse)

                // delete random token from database and save auth credentials
                val randomTokenDeleteRequest = RandomTokenRepository.deleteRandomTokenByEmail(registerDTO.email)
                print(randomTokenDeleteRequest)

                val userCredentials = UserCredentials(
                    userId = userServiceResponse,
                    firstName = registerDTO.firstName,
                    lastName = registerDTO.lastName,
                    email = registerDTO.email,
                    passwordHash = registerDTO.password,
                    isLoggedIn = false
                )

                //save credentials
                UserCredentialRepository.saveUserCredential(userCredentials)

                return ApplicationResponses(message = CustomResponse(body = "User registered succesfully",status = true), statusCode = HttpStatusCode.Created)
        }
        return ApplicationResponses(message = CustomResponse(body = "Random Token not found",status = false), statusCode = HttpStatusCode.Conflict)
    }
}