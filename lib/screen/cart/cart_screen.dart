import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/controller/home_controller.dart';
import 'package:flutter_assessment_ziyad/model/address_model.dart';
import 'package:flutter_assessment_ziyad/model/cart_model.dart';
import 'package:flutter_assessment_ziyad/model/order_model.dart';
import 'package:flutter_assessment_ziyad/model/product_model.dart';
import 'package:flutter_assessment_ziyad/screen/shared/button_shared.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> carts = [];
  List<Address> addresses = [];
  HomeController h = Get.find();

  Future<void> loadCart() async {
    List<String>? encodedCarts = Preference.getStringList('cart');
    if (encodedCarts != null) {
      List<Cart> loadedCarts = [];
      for (String encodedCart in encodedCarts) {
        Map<String, dynamic> decodedCart = json.decode(encodedCart);

        loadedCarts.add(Cart.fromJson(decodedCart));
      }
      setState(() {
        carts = loadedCarts;
      });
    }
  }

  Future<void> deleteCart(Cart cartToDelete) async {
    List<String>? encodedCarts = Preference.getStringList('cart');
    if (encodedCarts != null) {
      List<Cart> updatedCarts = encodedCarts
          .map((encodedCart) => Cart.fromJson(json.decode(encodedCart)))
          .toList();

      updatedCarts.removeWhere((cart) => cart.cartid == cartToDelete.cartid);
      List<String> updatedEncodedCarts =
          updatedCarts.map((cart) => json.encode(cart.toJson())).toList();

      await Preference.setStringList('cart', updatedEncodedCarts);
      setState(() {
        carts = updatedCarts;
      });
    }
  }

  Future<void> loadDefaultAddress() async {
    List<String>? encodedAddresses = Preference.getStringList('address');
    if (encodedAddresses != null) {
      List<Address> loadedAddresses = [];
      for (String encodedAddress in encodedAddresses) {
        Map<String, dynamic> decodedAddress = json.decode(encodedAddress);
        Address address = Address.fromJson(decodedAddress);
        if (address.isDefault) {
          loadedAddresses.add(address);
        }
      }
      setState(() {
        addresses = loadedAddresses;
      });
    }
  }

  double calculateTotal() {
    double total = 0.0;
    for (Cart cart in carts) {
      total += ((100 - cart.product!.discountPercentage!) *
              cart.product!.price! /
              100) *
          cart.quantity;
    }
    return total;
  }

  Future<List?> getCarts() async {
    List<String>? encodedCarts = Preference.getStringList('cart');
    if (encodedCarts != null) {
      return encodedCarts
          .map((encodedCart) => json.decode(encodedCart))
          .toList();
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    loadCart();
    loadDefaultAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Preference.remove(Preference.cart);
            },
            child: const Text('My Cart')),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  carts.isEmpty
                      ? const Center(
                          child: Text('No product added'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: carts.length,
                          itemBuilder: (context, index) {
                            Cart cart = carts[index];
                            return Dismissible(
                              key: Key(cart.cartid.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                deleteCart(cart);
                              },
                              child: ListTile(
                                title: Text(cart.product!.title!),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price: ${((100 - cart.product!.discountPercentage!) * cart.product!.price! / 100).toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Total Price: ${(((100 - cart.product!.discountPercentage!) * cart.product!.price! / 100) * cart.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                                trailing: Text('Quantity: ${cart.quantity}'),
                                leading: Image.network(
                                  cart.product!.thumbnail!,
                                  fit: BoxFit.fill,
                                  width: 25.w,
                                ),
                              ),
                            );
                          },
                        ),
                  addresses.isEmpty
                      ? const Center(
                          child: Text('No addresses found'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            Address address = addresses[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed('/address')!
                                    .then((value) => loadDefaultAddress());
                              },
                              child: ListTile(
                                title: Text(address.name),
                                subtitle: Text(
                                    '${address.address} ${address.city}, ${address.state}, ${address.postcode}'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'RM ${calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SharedButton(
            title: "Confirm",
            isFilled: true,
            onTap: carts.isEmpty
                ? null
                : () async {
                    List<Map<String, dynamic>> productListJson = [];

                    for (Cart cart in carts) {
                      Map<String, dynamic> productMap = cart.product!.toJson();
                      productMap['quantity'] = cart.quantity;
                      productListJson.add(productMap);
                    }
                    Map<String, dynamic> addressJson = addresses.first.toJson();

                    List<Product> productList = [];

                    for (Map<String, dynamic> productJson in productListJson) {
                      productList.add(Product.fromJson(productJson));
                    }

                    Order order = Order(
                      orderId: Random().nextInt(100000) + 1,
                      productList: productList,
                      totalAmount: calculateTotal(),
                      orderDate: DateTime.now(),
                      address: Address.fromJson(addressJson),
                    );

                    Map<String, dynamic> orderJson = order.toJson();

                    List<String>? existingOrders =
                        Preference.getStringList(Preference.order);

                    List<Map<String, dynamic>> orders = [];

                    if (existingOrders != null) {
                      for (String existingOrder in existingOrders) {
                        orders.add(json.decode(existingOrder));
                      }
                    }
                    orders.add(orderJson);

                    List<String> orderStrings =
                        orders.map((order) => json.encode(order)).toList();

                    await Preference.setStringList(
                        Preference.order, orderStrings);

                    Preference.remove(Preference.cart);
                    Get.offAllNamed('/home');
                  },
          )
        ],
      ),
    );
  }
}
