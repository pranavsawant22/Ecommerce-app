package com.de_b1.service

import com.de_b1.models.schema.Order
import com.de_b1.repositories.OrderRepository

class OrderService {

    val ORepo = OrderRepository()
    suspend fun getOrderService(userID:String): List<Order?> {
        val wl: List<Order?> = ORepo.findOrderByUserId(userID)
        return wl
    }
    suspend fun getOrderServicebyOrderID(orderID:String): Order? {
        val wl: Order? = ORepo.findOrderByOrderId(orderID)
        return wl
    }
    suspend fun getOrderStatusService(order_id:String): String {
        val wl: String = ORepo.getOrderStatusByOrderId(order_id)
        return wl
    }
    suspend fun getUserByOrderId(order_id:String): String? {
        val wl: String? = ORepo.findUserByOrderId(order_id)
        return wl
    }
    suspend fun deleteOrder(order_id:String) {
        ORepo.DeleteOrder(order_id)
    }

    suspend fun addOrder(order_details: Order,status: String): Boolean {
        return ORepo.addOrder(order_details)
    }

    suspend fun updateOrderStatus(order_id: String, status: String): Boolean? {
        if (status == "not shipped") {
            return ORepo.updateOrderStatustoNotShipped(order_id)
        }
        else if (status == "delivered") {
            return ORepo.updateOrderStatustoDelivered(order_id)
        }
        else if (status == "cancelled") {
            return ORepo.updateOrderStatustoCancelled(order_id)
        }
        else {
            return null
        }
    }

}
