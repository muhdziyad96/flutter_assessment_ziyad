import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/controller/order_controller.dart';
import 'package:flutter_assessment_ziyad/model/order_model.dart';
import 'package:flutter_assessment_ziyad/model/product_model.dart';
import 'package:flutter_assessment_ziyad/screen/shared/cart_button_shared.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Order> orders = [];
  OrderController o = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List<String>? orderStrings = Preference.getStringList(Preference.order);
    if (orderStrings != null) {
      List<Order> loadedOrders = [];
      for (String orderString in orderStrings) {
        Map<String, dynamic> orderJson = json.decode(orderString);
        loadedOrders.add(Order.fromJson(orderJson));
      }
      setState(() {
        orders = loadedOrders;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Preference.remove(Preference.order);
            },
            child: const Text('Orders')),
        actions: const [CardButtonShared()],
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders found'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Order order = orders[index];
                return ListTile(
                  title: Text('Order ID: ${order.orderId}'),
                  subtitle: Text(
                    order.productList
                            ?.map((product) => product.title)
                            .join(', ') ??
                        '',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        'RM${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(order.orderDate),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      o.orderId = order.orderId;
                    });
                    Get.toNamed('/historyDetails');
                  },
                );
              },
            ),
    );
  }
}
