package com.de_b1.route

import com.de_b1.models.StatusDTO
import com.de_b1.models.schema.Order
import com.de_b1.models.schema.OrderItem
import com.de_b1.models.schema.Status
import com.de_b1.service.OrderService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.util.*


fun Route.orderFeautureRouting() {
    val orderService = OrderService()
    get("api/v1/order/get-all-orders") {
        try {
            val userId: String? = (call.request.headers["user_id"])
            val orders: List<Order?> = orderService.getOrderService(userId.toString())

            if (orders.isEmpty()) {
                call.respondText(text = "Order Something", status = HttpStatusCode.NotFound)
            }

            call.respond(HttpStatusCode.OK,orders.toList())
        }
        catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }

    }
    get("api/v1/order/get-order/{order_id}") {
        try {
            val userId: String? = (call.request.headers["user_id"])
            val orderId: String? = (call.parameters["order_id"])

            val orderByOrderId: Order? = orderService.getOrderServicebyOrderID(orderId.toString())
            val userByOrder: String? = orderService.getUserByOrderId(orderId.toString())
            val orders: MutableList<Order?> = mutableListOf()
            orders.add(orderByOrderId)

            if (orderByOrderId == null || userId != userByOrder) {
                call.respondText(text = "Invalid Order id or User id", status = HttpStatusCode.NotFound)
            }
            if (orders.size == 0) {
                call.respondText(text = "Order Something", status = HttpStatusCode.NotFound)
            }

            call.respond(HttpStatusCode.OK, orders)
        }
        catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }

    get("api/v1/order/order-status/{order_id}") {
        try {
            val userId: String? = (call.request.headers["user_id"])
            val orderId: String? = (call.parameters["order_id"])

            val statusByOrder: String = orderService.getOrderStatusService(orderId.toString())
            val userByOrder: String? = orderService.getUserByOrderId(orderId.toString())
            if (userId != userByOrder) {
                call.respondText(text = "Order Something", status = HttpStatusCode.NotFound)
            }

            call.respondText(status = HttpStatusCode.OK, text = statusByOrder)
        }
        catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }

    delete("api/v1/order/delete-order/{order_id}"){
        try {
            val orderId: String? = (call.parameters["order_id"])
            val orderByOrderId: Order? = orderService.getOrderServicebyOrderID(orderId.toString())

            if (orderByOrderId == null) {
                call.respondText(status = HttpStatusCode.NotFound, text = "Can't be deleted!")
            }

            orderService.deleteOrder(orderId.toString())
            call.respond(HttpStatusCode.OK, "Successfully deleted")
        }
        catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }

    post("api/v1/order/add-order") {
        try {
            val userId: String = call.request.headers["user_id"].toString()
            val orderDetails: Order = call.receive()
            val items: MutableList<OrderItem> = mutableListOf()
            val arr: MutableList<OrderItem> = orderDetails.items
            for (obj in arr) {
                val temp = OrderItem()
                temp.skuId = obj.skuId
                temp.price = obj.price
                items.add(temp)
            }
            val status:String=orderDetails.status.lowercase()
            if (status == "not shipped") {
                orderDetails.status=Status.NOT_SHIPPED.status
            }
            else if (status == "delivered") {
                orderDetails.status=Status.DELIVERED.status
            }
            else if (status == "cancelled") {
                orderDetails.status=Status.CANCELLED.status
            }
            orderDetails._id = UUID.randomUUID().toString()
            orderDetails.items = items
            orderDetails.userId = userId
            if (!orderService.addOrder(orderDetails,status)) {
                call.respond(HttpStatusCode.BadRequest, "Something went wrong. Order can not be added")
                return@post
            }

            call.respond(HttpStatusCode.OK, "Order can be seen in Order History")
        }
        catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }

    post("api/v1/order/update-order-status") {
        try {
            val userId = call.request.headers["user_id"].toString()
            val orderDetails = call.receive<StatusDTO>()
            val orderId = orderDetails.orderId
            val status = orderDetails.status.lowercase()

            val getUserId = orderService.getUserByOrderId(orderId)
            val getStatusUpdate = orderService.updateOrderStatus(orderId, status)

            if (getStatusUpdate == null) {
                call.respond(HttpStatusCode.BadRequest, "Retry with correct status")
                return@post
            }

            if (getUserId != userId || getStatusUpdate == false) {
                call.respond(HttpStatusCode.NotFound, "User Id or Order Id is invalid")
                return@post
            }

            call.respond(HttpStatusCode.OK, "Order status has been updated to ${status.uppercase()}")
        }
        catch (cause: Throwable) {
            println("catch")
            call.respond(message = cause.localizedMessage, status = HttpStatusCode.BadRequest)
            call.application.environment.log.error(cause.localizedMessage)
            call.application.environment.log.error(cause.stackTrace.toString())
        }
    }

}
