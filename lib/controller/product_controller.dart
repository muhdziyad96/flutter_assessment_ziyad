import 'package:flutter_assessment_ziyad/model/product_model.dart';
import 'package:flutter_assessment_ziyad/services/product_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  int? productId;
  var productById = Product().obs;

  Future<void> getProductById(int id) async {
    final Product? response = await ProductService().getProductById(productId!);
    productById.value = response!;
    update();
  }
}
