package com.de_b1.plugins


import io.ktor.server.application.*
import io.ktor.server.http.content.*

import io.ktor.server.routing.*
import com.de_b1.route.orderFeautureRouting
import io.ktor.serialization.gson.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.plugins.contentnegotiation.*


fun Application.configureRouting() {
    install(ContentNegotiation) {
        gson {
        }
        json()
    }
    routing {
        orderFeautureRouting()
        // Static plugin. Try to access `/static/index.html`
        static("/static") {
            resources("static")
        }
    }
}

