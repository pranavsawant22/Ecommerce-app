package com.de_b1.service

import com.de_b1.models.ApplicationResponses
import com.de_b1.models.CustomResponse
import com.de_b1.models.dto.ChangePasswordDTO
import com.de_b1.models.dto.UpdatePasswordDTO
import com.de_b1.models.schema.UserCredentials
import com.de_b1.repositories.UserCredentialRepository
import io.ktor.http.*
import org.mindrot.jbcrypt.BCrypt

class PasswordService {



    suspend fun changePassword(userId:String,
                               changePasswordDTO: ChangePasswordDTO): ApplicationResponses {
        val userCredentials: UserCredentials? = UserCredentialRepository.findUserCredentialByUserId(userId)

        println(userCredentials.toString())
        if(userCredentials == null){
            return ApplicationResponses(
                message = CustomResponse(body = "No user found with given userId",status = false),
                statusCode = HttpStatusCode.BadRequest)
        }
        else if(!BCrypt.checkpw(changePasswordDTO.oldPassword,userCredentials.passwordHash)) {
            return ApplicationResponses(
                message = CustomResponse(body = "Invalid Email/Password",status = false),
                statusCode = HttpStatusCode.Conflict
            )
        }
        userCredentials.passwordHash = BCrypt.hashpw(changePasswordDTO.newPassword, BCrypt.gensalt())
        UserCredentialRepository.saveUserCredential(userCredentials)
        return ApplicationResponses(
            message = CustomResponse(body = "Password Updated Successfully",status = true),
            statusCode = HttpStatusCode.OK
        )
    }

    suspend fun updatePassword(emailId: String, updatePasswordDTO: UpdatePasswordDTO): ApplicationResponses {
        val userCredentials: UserCredentials? = UserCredentialRepository.findUserCredentialByEmail(emailId)

        println(userCredentials.toString())
        if (userCredentials == null) {
            return ApplicationResponses(
                message = CustomResponse(body = "No user found with given emailId",status = false),
                statusCode = HttpStatusCode.BadRequest
            )
        }
        if (BCrypt.checkpw(updatePasswordDTO.newPassword, userCredentials.passwordHash)) {
            return ApplicationResponses(
                message = CustomResponse(body = "Same as old password",status = false),
                statusCode = HttpStatusCode.BadRequest
            )
        }
        userCredentials.passwordHash = BCrypt.hashpw(updatePasswordDTO.newPassword, BCrypt.gensalt())
        UserCredentialRepository.saveUserCredential(userCredentials)
        return ApplicationResponses(
            message = CustomResponse(body = "Password Updated",status = true),
            statusCode = HttpStatusCode.OK
        )
    }
}