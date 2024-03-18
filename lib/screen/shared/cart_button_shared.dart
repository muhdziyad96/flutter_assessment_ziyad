import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardButtonShared extends StatefulWidget {
  const CardButtonShared({super.key});

  @override
  State<CardButtonShared> createState() => _CardButtonSharedState();
}

class _CardButtonSharedState extends State<CardButtonShared> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.toNamed('/cart');
        },
        icon: const Icon(Icons.shopping_cart_outlined));
  }
}
