import 'package:flutter_assessment_ziyad/controller/product_controller.dart';
import 'package:flutter_assessment_ziyad/model/product_model.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductService {
  ProductController pd = Get.find();

  Future<List<Product>> getProductList() async {
    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        var results = responseData['products'];
        List<Product> productList =
            List.from(results.map((data) => Product.fromJson(data)));

        return productList;
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        var results = responseData['products'];

        var productData = results.firstWhere(
          (data) => data['id'] == id,
          orElse: () => null,
        );

        if (productData != null) {
          return Product.fromJson(productData);
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }
}
