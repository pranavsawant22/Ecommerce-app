package com.de_b1.models

import io.ktor.http.*
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
data class ApplicationResponses (
    @Contextual
    val message:CustomResponse,
    @Contextual
    val statusCode:HttpStatusCode
        )

@Serializable
data class  CustomResponse(
    @Contextual
    val body: String,
    val status: Boolean

)
