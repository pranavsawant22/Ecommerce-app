package com.de_b1.models.DTO

data class ConfigurationDTO(
    val databaseUrl: String,
    val databaseName: String,
    val port: Int,
)