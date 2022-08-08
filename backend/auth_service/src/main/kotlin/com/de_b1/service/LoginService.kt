package com.de_b1.service

import com.de_b1.models.ApplicationResponses
import com.de_b1.models.CustomResponse
import com.de_b1.models.dto.UserLoginDTO
import com.de_b1.models.schema.LoginHistory
import com.de_b1.models.schema.UserCredentials
import com.de_b1.repositories.LoginHistoryRepository
import com.de_b1.repositories.UserCredentialRepository
import com.de_b1.utils.JWTTokenManager
import io.ktor.http.*
import org.mindrot.jbcrypt.BCrypt
import java.util.*

class LoginService {

    suspend fun loginUser(userLoginDTO: UserLoginDTO): ApplicationResponses {
        val userCredentials: UserCredentials? = UserCredentialRepository.findUserCredentialByEmail(userLoginDTO.email)
        val jwtTokenManager: JWTTokenManager = JWTTokenManager()

        if (userCredentials == null) {
            return ApplicationResponses(
                CustomResponse(body = "User not found in DB",status = false),
                statusCode = HttpStatusCode.Conflict
            )
        } else if (!BCrypt.checkpw(userLoginDTO.password, userCredentials.passwordHash)) {
            val loginHistory = LoginHistory(
                userId = userCredentials.userId,
                success = false,
                client = userLoginDTO.client,
                typeOfLogin = userLoginDTO.typeOfLogin!!
            )

            LoginHistoryRepository.saveLoginHistory(loginHistory = loginHistory)
            return ApplicationResponses(
                CustomResponse(body = "Invalid Email/Password",status = false),
                statusCode = HttpStatusCode.Conflict
            )
        } else if (userCredentials.isLoggedIn &&
            userCredentials.jwtExpiryDate.after(Date(System.currentTimeMillis()))
        ) {
            val loginHistory = LoginHistory(
                userId = userCredentials.userId,
                success = false,
                client = userLoginDTO.client,
                typeOfLogin = userLoginDTO.typeOfLogin!!
            )

            LoginHistoryRepository.saveLoginHistory(loginHistory = loginHistory)
            return ApplicationResponses(
                CustomResponse(body = "User logged in from another device",status = false),
                statusCode = HttpStatusCode.Forbidden
            )
        }

        //generate jwt token

        val (jwtAccessToken, jwtExpiryDate) = jwtTokenManager.generateJWTToken(userCredentials)


        //save token in userdb
        userCredentials.jwtAccessToken = jwtAccessToken
        //mark user as loggedin
        userCredentials.isLoggedIn = true
        userCredentials.jwtExpiryDate = jwtExpiryDate
        UserCredentialRepository.saveUserCredential(userCredentials)
        //save login history
        val loginHistory = LoginHistory(
            userId = userCredentials.userId,
            success = true,
            client = userLoginDTO.client,
            typeOfLogin = userLoginDTO.typeOfLogin!!
        )

        LoginHistoryRepository.saveLoginHistory(loginHistory = loginHistory)
        //return token
        return ApplicationResponses(message = CustomResponse(body = jwtAccessToken!!,status = true), statusCode = HttpStatusCode.OK)
    }

}