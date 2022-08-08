package com.de_b1.plugins

import com.de_b1.httpClient
import com.de_b1.models.dto.RandomTokenDTO
import com.de_b1.models.dto.UserProfileDTO
import com.de_b1.models.schema.RandomToken
import com.de_b1.models.schema.UserCredentials
import com.de_b1.repositories.RandomTokenRepository
import com.de_b1.repositories.UserCredentialRepository
import com.de_b1.routes.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.coroutines.runBlocking
import org.mindrot.jbcrypt.BCrypt
import javax.security.sasl.AuthenticationException

fun Application.configureRouting() {
    install(StatusPages) {
        exception<AuthenticationException> { call, cause ->
            call.respond(HttpStatusCode.Unauthorized)
        }

    }
    routing {
        configureRegisterRoute()
        configureLoginRoute()
        configureLogoutRoute()
        configureChangePasswordRoute()
        configureCheckEmailRoute()
        configureUpdatePasswordRoute()
        configureValidateOtp()
        configureSendOtp()
        configureGatewayRouting()

        get("/a") {
            println("hello")
            val userCredentials = UserCredentials(
                userId = "srijibb",
                email = "helloo@gmail.com",
                firstName = "srijib",
                lastName = "bose",
                passwordHash = BCrypt.hashpw("simple", BCrypt.gensalt()),
                isLoggedIn = true
            )
            println(userCredentials)
            println("repo")
            UserCredentialRepository.saveUserCredential(userCredentials)
            println("user saved")
        }

        get("/b") {
//            println("hello")
//            val userCredentials = UserCredentials(userId = "srijib", email = "hello.gmail.com", passwordHash = "jhgjchg", isLoggedIn = true)
//            println(userCredentials)
//            println("repo")
//            val email = UserCredentialRepository.findUserCredentialByEmail(userCredentials.email).toString()
//            call.respond(email)
//            println("user saved")
            UserCredentialRepository.findUserCredentialByUserId("srijibb")
        }

        get("/d") {
            val deleteResult = UserCredentialRepository.findUserCredentialById("be32b652-5959-48e0-9ad4-e627da36614f").toString()
            call.respond(deleteResult)
            println("user deleted")
        }

        get ("/excited") {
//            val mailService = MailGunService().sendSimpleMessage()
//            call.respond(mailService)
//            println(mailService.message)
        }

        get("/happiness") {
            runBlocking {
                val response = httpClient.get("https://reqres.in/api/users?page=2")
//            val response: HttpResponse = httpClient.request("") {
//                method = HttpMethod.Get
//            }
//                print(response.bodyAsText())
                call.respond(message = response.bodyAsChannel(),status = response.status)
            }
        }

        post ("/addRandomStringInDB") {
            val randomTokenDTO = call.receive<RandomTokenDTO>()
            val randomToken = RandomToken(email = randomTokenDTO.email)
            RandomTokenRepository.saveRandomToken(randomToken)
            call.respond("newuserid")
        }

        post ("/checkUserProfile") {
            val userProfileDTO = call.receive<UserProfileDTO>()
            call.respond("userid")
        }
    }
}
