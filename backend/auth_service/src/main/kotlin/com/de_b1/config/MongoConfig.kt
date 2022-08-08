package com.de_b1.config

import ch.qos.logback.classic.LoggerContext
import com.mongodb.ConnectionString
import com.mongodb.MongoClientSettings
import com.mongodb.connection.ConnectionPoolSettings
import org.litote.kmongo.coroutine.CoroutineClient
import org.litote.kmongo.coroutine.CoroutineDatabase
import org.litote.kmongo.coroutine.coroutine
import org.litote.kmongo.reactivestreams.KMongo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.concurrent.TimeUnit

object MongoConfig {
    private val log: Logger = LoggerFactory.getLogger(javaClass)
    private var client: CoroutineClient
    private var database: CoroutineDatabase


    init {
        log.info("Mongo Config Loaded")
        client = KMongo.createClient(
            MongoClientSettings.builder()
                .applyConnectionString(ConnectionString(Configuration.env.databaseUrl))
                .applyToConnectionPoolSettings {
                    ConnectionPoolSettings.builder().maxConnectionIdleTime(120000, TimeUnit.MILLISECONDS)
                        .minSize(10).maxSize(40)
                }
                .applicationName("NativeCommerceOrder")
                .build()).coroutine
        database = client.getDatabase(Configuration.env.databaseName)
        log.info("Connected to MongoDB")
    }

    fun getDatabase(): CoroutineDatabase {
        return database
    }
}