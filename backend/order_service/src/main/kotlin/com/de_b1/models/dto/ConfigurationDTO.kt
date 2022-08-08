package com.de_b1.models.dto

data class ConfigurationDTO(
    val databaseUrl: String,
    val databaseName: String,
    val port: Int,
)