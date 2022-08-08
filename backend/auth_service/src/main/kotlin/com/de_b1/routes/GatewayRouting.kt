package com.de_b1.routes

import com.de_b1.HoconConfiguration
import com.de_b1.httpClient
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.patch
import io.ktor.server.resources.post
import io.ktor.server.resources.put
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import kotlin.collections.set

@Serializable
@Resource("{param...}")
class GatewayRouting(val parent: BaseRoute = BaseRoute())

private val hoconConfiguration: HoconConfiguration = HoconConfiguration()
private val portMap = mapOf("cart" to "8081")
private val urlMap = mapOf("cart" to (hoconConfiguration.config?.property("services.cart_service_route")?.getString() ?: ""))

fun Route.configureGatewayRouting() {


    get("/api/v1/rating-review/get-rating-review-by-productid/{productId}"){
        println(call.request.uri)
        println(call.request.httpMethod)
        println(call.parameters.getAll("param"))
        println(call.request.headers.entries().forEach { println(it.key);println(it.value.get(0)) })

        val route = "https://rating-review-service-capstone.herokuapp.com"
        val response: HttpResponse = httpClient.request(
            route
                    + call.request.uri
        ) {
            method = HttpMethod.Get
//            headers {
//                call.request.headers.entries().forEach {
//                    return@forEach append(it.key, it.value[0])
//                }
//            }

        }
//            print("hello"+response.bodyAsText())
        call.respond(response.bodyAsChannel())
    }
    authenticate {

        get<GatewayRouting> {
            println(call.request.uri)
            println(call.request.httpMethod)
            println(call.parameters.getAll("param"))
            println(call.request.headers.entries().forEach { println(it.key);println(it.value.get(0)) })

            val principal = call.principal<JWTPrincipal>()
            val userId = principal!!.payload.getClaim("user_id").asString()
            val route = urlMap.get(call.parameters.getAll("param")?.get(0))
            val response: HttpResponse = httpClient.request(
                route
                        + portMap.get(
                    call.parameters.getAll("param")?.get(0)
                ) + call.request.uri
            ) {
                method = HttpMethod.Get
                headers {
                    call.request.headers.entries().forEach {
                        return@forEach append(it.key, it.value.get(0))
                    }
                    append("user_id",userId)
                }

            }
//            print("hello"+response.bodyAsText())
            call.respond(response.bodyAsChannel())

        }
        post<GatewayRouting> {
            println(call.request.uri)
            println(call.request.httpMethod)
            println(call.parameters.getAll("param")?.get(0))
            val entrymap = HashMap<String, String>()
            println(call.request.headers.entries().forEach { println(it.key);println(it.value.get(0)) })
//        println(call.receiveText())
            call.request.headers.entries().forEach {
                if (it.key != "content-length") {
                    entrymap[it.key] = it.value.get(0)
                }

            }

            val principal = call.principal<JWTPrincipal>()
            val userId = principal!!.payload.getClaim("user_id").asString()
            val route = urlMap.get(call.parameters.getAll("param")?.get(0))
            val port = portMap.get(call.parameters.getAll("param")?.get(0))
            println("http://localhost:" + port + call.request.uri)
            val response: HttpResponse = httpClient.request(route + port + call.request.uri) {
                method = HttpMethod.Post
                headers {
                    entrymap.forEach {
                        return@forEach append(it.key, it.value)
                    }
                    append("user_id",userId)
                }
                setBody(call.receiveChannel())

            }
//            print("hello"+response.bodyAsText())
            call.respond(response.bodyAsChannel())

        }
        patch<GatewayRouting> {
            println(call.request.uri)
            println(call.request.httpMethod)
            println(call.parameters.getAll("param")?.get(0))
            val entrymap = HashMap<String, String>()
            println(call.request.headers.entries().forEach { println(it.key);println(it.value.get(0)) })
//        println(call.receiveText())
            call.request.headers.entries().forEach {
                if (it.key != "content-length") {
                    entrymap[it.key] = it.value.get(0)
                }

            }
            val principal = call.principal<JWTPrincipal>()
            val userId = principal!!.payload.getClaim("user_id").asString()
            val route = urlMap.get(call.parameters.getAll("param")?.get(0))
            val port = portMap.get(call.parameters.getAll("param")?.get(0))
            println("http://localhost:" + port + call.request.uri)
            val response: HttpResponse = httpClient.request(route + port + call.request.uri) {
                method = HttpMethod.Patch
                headers {
                    entrymap.forEach {
                        return@forEach append(it.key, it.value)
                    }
                    append("user_id",userId)
                }
                setBody(call.receiveChannel())

            }
//            print("hello"+response.bodyAsText())
            call.respond(response.bodyAsChannel())

        }
        delete<GatewayRouting> {
            println(call.request.uri)
            println(call.request.httpMethod)
            println(call.parameters.getAll("param")?.get(0))
            val entrymap = HashMap<String, String>()
            println(call.request.headers.entries().forEach { println(it.key);println(it.value.get(0)) })
//        println(call.receiveText())
            call.request.headers.entries().forEach {
                if (it.key != "content-length") {
                    entrymap[it.key] = it.value.get(0)
                }

            }
            val principal = call.principal<JWTPrincipal>()
            val userId = principal!!.payload.getClaim("user_id").asString()
            val route = urlMap.get(call.parameters.getAll("param")?.get(0))
            val port = portMap.get(call.parameters.getAll("param")?.get(0))
            println("http://localhost:" + port + call.request.uri)
            val response: HttpResponse = httpClient.request(route + port + call.request.uri) {
                method = HttpMethod.Delete
                headers {
                    entrymap.forEach {
                        return@forEach append(it.key, it.value)
                    }
                    append("user_id",userId)
                }
                setBody(call.receiveChannel())

            }
//            print("hello"+response.bodyAsText())
            call.respond(response.bodyAsChannel())

        }
        put<GatewayRouting> {
            println(call.request.uri)
            println(call.request.httpMethod)
            println(call.parameters.getAll("param")?.get(0))
            val entrymap = HashMap<String, String>()
            println(call.request.headers.entries().forEach { println(it.key);println(it.value.get(0)) })
//        println(call.receiveText())
            call.request.headers.entries().forEach {
                if (it.key != "content-length") {
                    entrymap[it.key] = it.value.get(0)
                }

            }
            val principal = call.principal<JWTPrincipal>()
            val userId = principal!!.payload.getClaim("user_id").asString()
            val route = urlMap.get(call.parameters.getAll("param")?.get(0))
            val port = portMap.get(call.parameters.getAll("param")?.get(0))
            println("http://localhost:" + port + call.request.uri)
            val response: HttpResponse = httpClient.request(route + port + call.request.uri) {
                method = HttpMethod.Put
                headers {
                    entrymap.forEach {
                        return@forEach append(it.key, it.value)
                    }
                    append("user_id",userId)
                }
                setBody(call.receiveChannel())

            }
//            print("hello"+response.bodyAsText())
            call.respond(response.bodyAsChannel())

        }
    }

}
