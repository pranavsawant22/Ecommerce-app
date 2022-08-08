package com.de_b1.routes

import com.de_b1.API_PREFIX
import io.ktor.resources.*
import kotlinx.serialization.Serializable

@Serializable
@Resource("${API_PREFIX}")
class BaseRoute()