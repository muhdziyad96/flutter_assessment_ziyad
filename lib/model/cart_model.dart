import 'package:flutter_assessment_ziyad/model/product_model.dart';

class Cart {
  final int cartid;
  final Product? product;
  num quantity;

  Cart({
    required this.cartid,
    this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'cartid': cartid,
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartid: json['cartid'],
      product:
          json["product"] != null ? Product.fromJson(json["product"]) : null,
      quantity: json['quantity'],
    );
  }
}
