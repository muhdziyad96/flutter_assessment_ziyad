import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/controller/product_controller.dart';
import 'package:flutter_assessment_ziyad/model/cart_model.dart';
import 'package:flutter_assessment_ziyad/model/product_model.dart';
import 'package:flutter_assessment_ziyad/screen/shared/button_shared.dart';
import 'package:flutter_assessment_ziyad/screen/shared/cart_button_shared.dart';
import 'package:flutter_assessment_ziyad/screen/shared/shimmer_loading_shared.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ProductController pd = Get.find();
  late Future<Product?> getProductById;

  @override
  void initState() {
    super.initState();
    pd.getProductById(pd.productId!);
  }

  void _showQuantityBottomSheet(BuildContext context, Product product) {
    int quantity = 1;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose Quantity',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.2.w),
                    child: Row(
                      children: [
                        Obx(() => ShimmerLoading(
                              isLoading:
                                  pd.productById.value.id != pd.productId,
                              child: Image.network(
                                pd.productById.value.thumbnail ??
                                    'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
                                width: 35.w,
                              ),
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.2.w),
                                child: Text(
                                  product.title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.2.w),
                                child: Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'RM',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 171, 34, 34),
                                            ),
                                          ),
                                          TextSpan(
                                            text: ((100 -
                                                        pd.productById.value
                                                            .discountPercentage!) *
                                                    pd.productById.value
                                                        .price! /
                                                    100)
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 171, 34, 34),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  SharedButton(
                    title: 'Add to cart',
                    isFilled: false,
                    onTap: () async {
                      Map<String, dynamic> cardData = {
                        'cartid': Random().nextInt(100000) + 1,
                        'product': product.toJson(),
                        'quantity': quantity,
                      };
                      await saveCart(cardData).then((value) => Get.back());
                      Get.snackbar(
                        'Success',
                        'Added to cart',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        borderRadius: 8,
                        margin: EdgeInsets.symmetric(
                            horizontal: 4.2.w, vertical: 1.23.h),
                        duration: const Duration(seconds: 3),
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
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

  Future<void> saveCart(Map<String, dynamic> cartData) async {
    List<String>? encodedCarts = Preference.getStringList('cart');
    List<Cart> updatedCarts = [];

    if (encodedCarts != null) {
      updatedCarts = encodedCarts
          .map((encodedCart) => Cart.fromJson(json.decode(encodedCart)))
          .toList();

      bool productExists = false;
      for (Cart cart in updatedCarts) {
        if (cart.product?.id == cartData['product']['id']) {
          cart.quantity += cartData['quantity'];
          productExists = true;
          break;
        }
      }

      if (!productExists) {
        updatedCarts.add(Cart.fromJson(cartData));
      }
    } else {
      updatedCarts.add(Cart.fromJson(cartData));
    }

    List<String> updatedEncodedCarts =
        updatedCarts.map((cart) => json.encode(cart.toJson())).toList();
    await Preference.setStringList('cart', updatedEncodedCarts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(pd.productById.value
              .getProductNameOrLoading(pd.productById.value, pd.productId!)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          const CardButtonShared()
        ],
      ),
      body: Shimmer(
        linearGradient: shimmerGradient,
        child: Column(
          children: [
            Obx(() => ShimmerLoading(
                  isLoading: pd.productById.value.id != pd.productId,
                  child: Image.network(pd.productById.value.thumbnail ??
                      'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg'),
                )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2.1.w),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Obx(
                      () => SingleChildScrollView(
                        physics: pd.productById.value.id != pd.productId
                            ? const NeverScrollableScrollPhysics()
                            : null,
                        child: Column(
                          children: [
                            Obx(
                              () => Padding(
                                padding: EdgeInsets.all(2.1.w),
                                child: ShimmerLoading(
                                  isLoading:
                                      pd.productById.value.id != pd.productId,
                                  child: _buildList(
                                      pd.productById.value.id != pd.productId,
                                      pd.productById.value,
                                      context),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            SharedButton(
              title: 'Add to cart',
              isFilled: false,
              onTap: () async {
                _showQuantityBottomSheet(context, pd.productById.value);
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget shimmerContainer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 250,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 300,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 150,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 250,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: double.infinity,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 150,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 500,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: 150,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: double.infinity,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ],
  );
}

Widget _buildList(bool isLoading, Product gameData, BuildContext context) {
  if (isLoading) {
    return shimmerContainer();
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.1.w),
          child: Row(
            children: [
              SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: gameData.rating ?? 0,
                  size: 30.0,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  spacing: 0.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.1.w),
                child: Text('${gameData.rating} / 5 '),
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'RM',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 171, 34, 34),
                        ),
                      ),
                      TextSpan(
                        text: ((100 - gameData.discountPercentage!) *
                                gameData.price! /
                                100)
                            .toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 171, 34, 34),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.1.w),
                  child: Text(
                    'RM${gameData.price!.toString()}',
                    style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadiusDirectional.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.all(1.w),
                    child: Text(
                      '-${gameData.discountPercentage!.toString()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Stock: '),
                Text(gameData.stock.toString()),
              ],
            ),
          ],
        ),
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Product Name: '),
            Expanded(child: Text(gameData.title!)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Brand: '),
            Expanded(child: Text(gameData.brand!)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category: '),
            Expanded(child: Text(gameData.category!)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description: '),
            Expanded(child: Text(gameData.description!)),
          ],
        ),
        const Divider(),
        if (gameData.images != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.2.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final shortScreenshots in gameData.images!)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Image.network(
                              shortScreenshots,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            shortScreenshots,
                            fit: BoxFit.fill,
                            height: 13.h,
                            width: 40.w,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
