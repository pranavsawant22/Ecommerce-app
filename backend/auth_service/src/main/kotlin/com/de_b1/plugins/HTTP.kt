package com.de_b1.plugins

import io.ktor.server.plugins.defaultheaders.*
import io.ktor.http.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.request.*

fun Application.configureHTTP() {
    install(DefaultHeaders) {
        header("X-Engine", "Ktor") // will send this header with each response
    }
    install(CORS) {
        allowMethod(HttpMethod.Options)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
        allowMethod(HttpMethod.Patch)
        allowHeader(HttpHeaders.Authorization)
        allowHeader(HttpHeaders.ContentType)
        allowHeadersPrefixed("custom-email")
        allowHeader("email")
        allowHeader("randomToken")
        allowHeader("typeOfLogin")
        allowHeader("email_id")
        allowHeader("client")
        exposeHeader("email")
        exposeHeader("randomToken")
        exposeHeader("email_id")
        exposeHeader("typeOfLogin")
        exposeHeader("client")
        anyHost() // @TODO: Don't do this in production if possible. Try to limit it.

    }
}
