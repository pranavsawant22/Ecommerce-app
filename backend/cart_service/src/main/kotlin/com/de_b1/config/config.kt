package com.de_b1.config

import com.de_b1.HoconConfiguration
import com.de_b1.models.dto.ConfigurationDTO

object Configuration {
     lateinit var env: ConfigurationDTO

    fun initConfig(environment: HoconConfiguration) {
        env = ConfigurationDTO(
            databaseUrl = environment.config?.property("ktor.envConfig.db.database_url")?.getString() ?: "",
            databaseName = environment.config?.property("ktor.envConfig.db.database_name")?.getString() ?: "",
            port = environment.config?.property("ktor.deployment.port")?.getString()?.toInt() ?: 8080,
        )
    }
}