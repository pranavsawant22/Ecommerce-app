package com.de_b1.models

import io.ktor.http.*

data class ApplicationResponse (
    val message:String,
    val statusCode: HttpStatusCode
)


