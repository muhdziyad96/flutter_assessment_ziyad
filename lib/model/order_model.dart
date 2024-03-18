import 'package:flutter_assessment_ziyad/model/address_model.dart';
import 'package:flutter_assessment_ziyad/model/product_model.dart';

class Order {
  final int orderId;
  final List<Product>? productList;
  final num totalAmount;
  final DateTime orderDate;
  final Address? address;

  Order({
    required this.orderId,
    this.productList,
    required this.totalAmount,
    required this.orderDate,
    required this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderid'],
      productList: (json['productList'] as List<dynamic>?)
          ?.map((productJson) => Product.fromJson(productJson))
          .toList(),
      totalAmount: json['totalamount'],
      orderDate: DateTime.parse(json['orderdate']),
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderId,
      'productList': productList?.map((product) => product.toJson()).toList(),
      'totalamount': totalAmount,
      'orderdate': orderDate.toIso8601String(),
      'address': address?.toJson(),
    };
  }
}
