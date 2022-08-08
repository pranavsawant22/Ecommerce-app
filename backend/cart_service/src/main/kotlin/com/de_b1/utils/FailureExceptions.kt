package com.de_b1.utils

import io.ktor.http.*

data class FailureExceptions(
    val statuscode : HttpStatusCode ,
    val msg : String,
    val extra_msg:Boolean=false
): Exception(msg)


