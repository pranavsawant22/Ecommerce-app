package com.de_b1

import com.de_b1.config.Configuration
import com.de_b1.config.MongoConfig
import com.de_b1.plugins.configureRouting
import com.de_b1.plugins.configureSerialization
import com.typesafe.config.ConfigFactory
import io.ktor.server.config.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*


class HoconConfiguration{
    var config: HoconApplicationConfig? = null;

    constructor(){
        config = HoconApplicationConfig(ConfigFactory.load())
    }
}

fun main() {
    Configuration.initConfig(HoconConfiguration())
    MongoConfig.getDatabase()
    embeddedServer(Netty, port = Configuration.env.port, host = "0.0.0.0") {
        configureRouting()
        configureSerialization()
    }.start(wait = true)
}