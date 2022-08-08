package com.de_b1.repositories

import com.de_b1.config.MongoConfig
import com.de_b1.models.schema.Order
import com.de_b1.models.schema.Status
import org.litote.kmongo.eq
import org.litote.kmongo.setValue

class OrderRepository {
    private var OrderCollection = MongoConfig.getDatabase().getCollection<Order>()

    suspend fun findOrderByUserId(userId: String): List<Order?> {
        return OrderCollection.find(Order::userId eq userId).toList()
    }
    suspend fun findOrderByOrderId(orderId: String): Order? {
        return OrderCollection.findOneById(orderId)
    }
    suspend fun findUserByOrderId(order_id: String): String? {
        return OrderCollection.findOneById(order_id)?.userId
    }
    suspend fun getOrderStatusByOrderId(Orderid: String): String {
        return OrderCollection.findOneById(Orderid)?.status.toString()
    }

    suspend fun DeleteOrder(order_id: String) {
        OrderCollection.deleteOneById(order_id)
    }

    suspend fun addOrder(order_Details: Order): Boolean {
        return OrderCollection.insertOne(order_Details).wasAcknowledged()
    }

    suspend fun updateOrderStatustoDelivered(order_id: String): Boolean {
        println(Status.DELIVERED)
        return OrderCollection.updateOne(
            Order::_id eq order_id,
            setValue(Order::status, Status.DELIVERED.status)
        ).wasAcknowledged()
    }

    suspend fun updateOrderStatustoNotShipped(order_id: String): Boolean {
        return OrderCollection.updateOne(
            Order::_id eq order_id,
            setValue(Order::status, Status.NOT_SHIPPED.status)
        ).wasAcknowledged()
    }

    suspend fun updateOrderStatustoCancelled(order_id: String): Boolean {
        return OrderCollection.updateOne(
            Order::_id eq order_id,
            setValue(Order::status, Status.CANCELLED.status)
        ).wasAcknowledged()
    }

}

