import 'package:flutter_assessment_ziyad/routes/app_routes.dart';
import 'package:flutter_assessment_ziyad/screen/auth/login_screen.dart';
import 'package:flutter_assessment_ziyad/screen/auth/sign_up_screen.dart';
import 'package:flutter_assessment_ziyad/screen/cart/cart_screen.dart';
import 'package:flutter_assessment_ziyad/screen/history/history_details_screen.dart';
import 'package:flutter_assessment_ziyad/screen/history/history_screen.dart';
import 'package:flutter_assessment_ziyad/screen/home/home_screen.dart';
import 'package:flutter_assessment_ziyad/screen/main/details_screen.dart';
import 'package:flutter_assessment_ziyad/screen/profile/address/add_address_screen.dart';
import 'package:flutter_assessment_ziyad/screen/profile/address/address_screen.dart';
import 'package:flutter_assessment_ziyad/screen/splash_screen.dart';
import 'package:flutter_assessment_ziyad/screen/welcome_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static const home = AppRoutes.home;
  static const splashScreen = AppRoutes.splashScreen;

  static final pageList = [
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => const DetailScreen(),
    ),
    GetPage(
      name: AppRoutes.address,
      page: () => const AddressScreen(),
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddAddressScreen(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: AppRoutes.historyDetails,
      page: () => const HistoryDetailScreen(),
    ),
  ];
}
