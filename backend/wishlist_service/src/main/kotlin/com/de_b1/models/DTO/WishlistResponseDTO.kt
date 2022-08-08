package com.de_b1.models.DTO

import com.de_b1.models.schema.WishlistItem

data class WishlistResponseDTO (
    var id:String,
    var userid:String,
    var wishlistitems : MutableList<WishlistItem>?= mutableListOf()
)
