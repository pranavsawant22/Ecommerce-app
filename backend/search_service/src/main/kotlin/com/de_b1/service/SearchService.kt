package com.de_b1.service

import com.de_b1.models.Collections.SearchOutput
import org.typesense.model.SearchResult

public class SearchService{
    public suspend fun SearchHelper(sr: SearchResult, page: Int, perPageOP: Int): MutableList<SearchOutput> {
        val find = sr!!.found

        val searchOp:MutableList<SearchOutput> = mutableListOf()


            for (i in 0 until minOf(perPageOP,find)){

                val nameProduct:String = sr.hits[i].document["name"].toString()
                val descriptionProduct = sr.hits[i].document["description"].toString();
                val brandProduct = sr.hits[i].document["brand"].toString();
                val ratingProduct = sr.hits[i].document["rating"].toString();
                val kindProduct = sr.hits[i].document["kind"].toString();
                val productSkuName = sr.hits[i].document["productSkuName"].toString();
                val genderProduct = sr.hits[i].document["gender"].toString()?:"M";
                val priceProduct = sr.hits[i].document["price"].toString();
                val imageUrl = sr.hits[i].document["image_url"].toString();
                val slugProduct = sr.hits[i].document["slug"].toString();



                val node = SearchOutput(name = nameProduct, description = descriptionProduct, brand = brandProduct, rating = ratingProduct, kind = kindProduct,productSkuName=productSkuName,gender=genderProduct, price = priceProduct, image_url = imageUrl, slug = slugProduct)

                searchOp.add(node)

            }
        return searchOp;
        }


    }
