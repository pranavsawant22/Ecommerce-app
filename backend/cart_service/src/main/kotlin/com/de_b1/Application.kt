package com.de_b1

import com.de_b1.config.Configuration
import com.de_b1.config.MongoConfig
import io.ktor.server.application.*
import com.de_b1.plugins.*
import com.typesafe.config.ConfigFactory
import io.ktor.server.config.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class HoconConfiguration{
    var config: HoconApplicationConfig? = null;

    constructor(){
        config = HoconApplicationConfig(ConfigFactory.load())
    }
}

fun main() {
    Configuration.initConfig(HoconConfiguration())
    MongoConfig.getDatabase()
    embeddedServer(Netty, port = 8081, host = "0.0.0.0") {
              configureRouting()
              configureSerialization()


//            configureMonitoring()
//            configureHTTP()
//            configureSecurity()

    }.start(wait = true)
}