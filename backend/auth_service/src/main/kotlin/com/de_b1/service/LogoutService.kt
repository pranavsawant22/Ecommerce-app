package com.de_b1.service

import com.de_b1.repositories.UserCredentialRepository

class LogoutService {
    suspend fun logoutUser(userId:String){
        print(userId)
        UserCredentialRepository.deleteSessionCredentialsByUserId(userId)
    }
}