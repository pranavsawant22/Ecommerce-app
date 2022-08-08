package com.de_b1.plugins

import com.de_b1.HoconConfiguration
import com.de_b1.utils.JWTTokenManager
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.response.*

fun Application.configureSecurity() {
    
    authentication {
            jwt {
                val hoconConfiguration: HoconConfiguration = HoconConfiguration()
                val tokenManager = JWTTokenManager()

                verifier(
                    tokenManager.verifyToken()
                )

                validate { credential ->
                    if (credential.payload.getClaim("user_id").asString().isNotEmpty())
                        JWTPrincipal(credential.payload)
                    else
                        null
                }
                challenge { defaultScheme, realm ->
                    call.respond(HttpStatusCode.Unauthorized, "Token is not valid or has expired")
                }
            }
        }
}
