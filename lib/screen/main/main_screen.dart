import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/controller/product_controller.dart';
import 'package:flutter_assessment_ziyad/controller/profile_controller.dart';
import 'package:flutter_assessment_ziyad/controller/user_controller.dart';
import 'package:flutter_assessment_ziyad/model/product_model.dart';
import 'package:flutter_assessment_ziyad/screen/shared/cart_button_shared.dart';
import 'package:flutter_assessment_ziyad/services/product_service.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserController u = Get.find();
  ProfileController p = Get.find();
  ProductController pd = Get.put(ProductController());
  late Future<List<Product>> productList;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    u.getUsers();
    productList = ProductService().getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.1.w, horizontal: 2.1.w),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 15,
                    child: Icon(
                      p.iconImage ?? PhosphorIcons.cat,
                      color: whiteColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Text(
                "Hi, ${u.userData.value.name ?? "Loading..."}",
                style: const TextStyle(fontSize: 18, color: primaryColor),
              ),
            ],
          );
        }),
        actions: const [CardButtonShared()],
      ),
      body: Padding(
        padding: EdgeInsets.all(2.1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: productList,
                builder: (context, item) {
                  if (!item.hasData) {
                    return const Center(child: Text('Loading...'));
                  }
                  return item.data!.isEmpty
                      ? const Center(child: Text('No Product in List'))
                      : GridView.builder(
                          controller: _controller,
                          itemCount: item.data?.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 8.0,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () async {
                                pd.productId = item.data?[i].id;
                                Get.toNamed('/details');
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2.1.w),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(15),
                                      child: Image.network(
                                        item.data?[i].thumbnail ?? '',
                                        fit: BoxFit.fill,
                                        height: 13.h,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.data?[i].title ?? 'No Name',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: item.data?[i].rating ?? 0,
                                      size: 20.0,
                                      color: Colors.amber,
                                      borderColor: Colors.amber,
                                      spacing: 0.0),
                                  Text(
                                    'RM${item.data?[i].price.toString()}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget txtField({
  TextEditingController? controller,
  String? hintText,
  IconData? icon,
  bool? obscureText,
  TextInputType? keyboardType,
  void Function()? onTap,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.23.h),
    padding: EdgeInsets.only(left: 4.2.w),
    decoration: BoxDecoration(
      color: whiteColor,
      border: Border.all(color: primaryColor, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      onChanged: onChanged ?? (String value) {},
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        suffixIcon: InkWell(
          onTap: onTap ?? () {},
          child: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
      validator: validator,
    ),
  );
}
