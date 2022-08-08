package com.de_b1.models.Collections

@kotlinx.serialization.Serializable
data class SearchBody(

    var collection: String="products",
    var query_by:String?="productSkuName,kind,brand",
    val q:String?="",
    var sort_by:String?="price:asc",
    var page:Int?=1,
    var per_page:Int?=250,
    var filter_by:String?="",
){
    init {
        if (collection!="products") {
            collection = "products"
        }
    }
}