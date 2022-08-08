package com.de_b1.ClientConnect

import com.de_b1.HoconConfiguration
import java.time.Duration
import org.typesense.api.Client
import org.typesense.api.Configuration
import org.typesense.model.SearchParameters
import org.typesense.model.SearchResult
import org.typesense.resources.Node

public class SearchConnection {
    private val hoconConfiguration: HoconConfiguration = HoconConfiguration()
    val protocol = hoconConfiguration.config?.property("typesenseAuth.protocol")?.getString()
    val host = hoconConfiguration.config?.property("typesenseAuth.host")?.getString()
    val apiKey = hoconConfiguration.config?.property("typesenseAuth.apiKey")?.getString()
    val port = hoconConfiguration.config?.property("typesenseAuth.port")?.getString()

    suspend fun ClientCon(
        parameter: String,
        SortByParameters: String,
        page: Int,
        perPageOP: Int,
        collectionName: String,
        query_by: String,
        filter_by: String
    ): SearchResult? {
        /* adding node to typesense */
        val nodes = ArrayList<Node>()

        /*
        The below apikey is for typesense cloud
        */
        val res = Node( protocol, host, port)
        nodes.add(res)

        /* name of collection */
        val collectionName = collectionName

        val configuration =
            Configuration(nodes, Duration.ofSeconds(2), apiKey)

        val client = Client(configuration)


        try {
            /* Search Parameters */
            val searchParameters = SearchParameters()
                .q(parameter)
                .queryBy(query_by)
                .perPage(perPageOP)
                .page(page)
                .sortBy(SortByParameters)

            val searchResult = client.collections(collectionName).documents().search(searchParameters)

            return searchResult

        } catch (e: Exception) {

            throw RuntimeException(e)


        }
    }

}



