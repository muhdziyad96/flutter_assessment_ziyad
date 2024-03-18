import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/controller/order_controller.dart';
import 'package:flutter_assessment_ziyad/model/order_model.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  OrderController o = Get.find();

  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List<String>? encodedOrders = Preference.getStringList('order');
    if (encodedOrders != null) {
      List<Order> loadedOrders = encodedOrders
          .map((encodedOrder) => Order.fromJson(json.decode(encodedOrder)))
          .toList();

      Order? order =
          loadedOrders.firstWhere((order) => order.orderId == o.orderId);

      setState(() {
        orders = [order];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.2.w),
          child: Column(
            children: [
              for (Order order in orders) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order ID:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      order.orderId.toString(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      DateFormat('dd-MM-yyyy').format(order.orderDate),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Time:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      DateFormat('hh:mm a').format(order.orderDate),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Delivery Address',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.1.w),
                      child: Text(
                          '${order.address!.address} ${order.address!.city}, ${order.address!.state}, ${order.address!.postcode}'),
                    ),
                  ],
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.productList?.length ?? 0,
                  itemBuilder: (context, index) {
                    var product = order.productList![index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(product.title!),
                          subtitle: Text(
                            'Quantity: ${product.quantity}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                'RM${((100 - product.discountPercentage!) * product.price! / 100).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          leading: Image.network(
                            product.thumbnail!,
                            fit: BoxFit.cover,
                            width: 15.w,
                            height: 5.h,
                          ),
                          onTap: () {
                            setState(() {
                              o.orderId = order.orderId;
                            });
                            Get.toNamed('/historyDetails');
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(4.2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Total',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'RM ${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
