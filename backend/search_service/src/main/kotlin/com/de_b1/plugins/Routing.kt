package com.de_b1.plugins

import com.de_b1.ClientConnect.SearchConnection
import com.de_b1.models.Collections.SearchBody
import com.de_b1.models.Collections.SearchOutput
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import com.de_b1.service.SearchService
import org.typesense.model.SearchResult

fun Application.configureRouting() {


    routing {
        get("/") {
            call.respond("Hello World!")
        }
        post("/api/v1/search") {

            try {
                val searchResult: SearchResult?
                val SearchParameters = call.receive<SearchBody>()
                val search = SearchParameters.q
                val SortByParameters = SearchParameters.sort_by
                val page = SearchParameters.page
                val perPageOP = SearchParameters.per_page
                val query_by = SearchParameters.query_by
                val collection = SearchParameters.collection
                val filter_by = SearchParameters.filter_by
                searchResult = SearchConnection().ClientCon(
                    search!!,
                    SortByParameters!!,
                    page!!,
                    perPageOP!!,
                    collection,
                    query_by!!,
                    filter_by!!
                )
                val searchOp: MutableList<SearchOutput>?
                searchOp = SearchService().SearchHelper(searchResult!!, page, perPageOP)
                call.respond(HttpStatusCode.OK, searchOp)
            } catch (e: Exception) {
                call.respond(HttpStatusCode.BadRequest, e.message!!)
            }

        }

    }
}


