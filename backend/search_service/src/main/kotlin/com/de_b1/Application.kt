package com.de_b1


import com.de_b1.plugins.configureRouting
import com.typesafe.config.ConfigFactory
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.config.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.contentnegotiation.*
import org.typesense.model.*

class HoconConfiguration {
    var config: HoconApplicationConfig? = null

    constructor() {
        config = HoconApplicationConfig(ConfigFactory.load())
    }
}

fun main() {

    embeddedServer(Netty, port = 8084, host = "127.0.0.1") {
        install(ContentNegotiation){
            json()

        }
        configureRouting()

    }
        .start(wait = true)
}