package com.de_b1.utils

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.de_b1.HoconConfiguration
import com.de_b1.models.schema.UserCredentials
import java.util.*

class JWTTokenManager(private val hoconConfiguration: HoconConfiguration = HoconConfiguration()) {

    private val secret: String = hoconConfiguration.config?.property("jwt.secret")?.getString() ?: ""
    private val issuer: String = hoconConfiguration.config?.property("jwt.issuer")?.getString() ?: ""
    private val audience: String = hoconConfiguration.config?.property("jwt.audience")?.getString() ?: ""
    private val validitySeconds: Long =
        hoconConfiguration.config?.property("jwt.validityMilliSeconds")?.getString()?.toLong() ?: 8640000


    fun generateJWTToken(userCredentials: UserCredentials): Pair<String, Date> {

        println("Validity expiry time = " + hoconConfiguration.config?.property("jwt.validityMilliSeconds")?.getString()?.toLong() ?: 8640000)
        val expiryTime: Date = Date(System.currentTimeMillis() + validitySeconds)

        return Pair(
            JWT.create()
                .withAudience(audience)
                .withIssuer(issuer)
                .withClaim("user_id", userCredentials.userId)
                .withClaim("email", userCredentials.email)
                .withClaim("firstName",userCredentials.firstName)
                .withClaim("lastName",userCredentials.lastName)
                .withExpiresAt(expiryTime)
                .sign(Algorithm.HMAC256(secret)),
            expiryTime
        )
    }
    
    fun verifyToken(): JWTVerifier {
        return JWT.require(Algorithm.HMAC256(secret))
            .withAudience(audience)
            .withIssuer(issuer)
            .build()
    }
}