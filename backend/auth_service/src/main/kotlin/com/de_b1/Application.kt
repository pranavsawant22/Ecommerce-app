package com.de_b1

import com.de_b1.config.Configuration
import com.de_b1.config.MongoConfig
import com.de_b1.plugins.*
import com.typesafe.config.ConfigFactory
import io.ktor.client.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.config.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.resources.*

class HoconConfiguration{
    var config: HoconApplicationConfig? = null;

    constructor(){
        config = HoconApplicationConfig(ConfigFactory.load())
    }
}

const val API_PREFIX = "/api/v1"
val httpClient: HttpClient = HttpClient(CIO) {
    install(ContentNegotiation) {
        json()
    }
}

fun main() {
        Configuration.initConfig(HoconConfiguration())
        MongoConfig.getDatabase()
        embeddedServer(Netty, port = Configuration.env.port, host = "0.0.0.0") {
            install(Resources)
            configureRouting()
            configureSerialization()
//            configureMonitoring()
            configureMicrometerMetric()
            configureHTTP()
            configureSecurity()

        }.start(wait = true)
}