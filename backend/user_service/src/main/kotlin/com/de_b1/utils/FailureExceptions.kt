package com.de_b1.utils

import io.ktor.http.*

data class FailureExceptions(
    val status : HttpStatusCode ,
    val msg : String
): Exception(msg)
