import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/controller/home_controller.dart';
import 'package:flutter_assessment_ziyad/controller/profile_controller.dart';
import 'package:flutter_assessment_ziyad/controller/user_controller.dart';
import 'package:flutter_assessment_ziyad/routes/app_pages.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => ProfileController(), fenix: true);
  HttpOverrides.global = MyHttpOverrides();
  await Preference.init();
  Preference.getBool(Preference.showOnboard) ??
      Preference.setBool(Preference.showOnboard, true);
  Preference.getBool(Preference.isLogin) ??
      Preference.setBool(Preference.isLogin, false);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EazyMart',
        builder: (context, child) {
          return SafeArea(
            minimum: EdgeInsets.only(top: 5.h),
            child: Scaffold(
              body: child,
            ),
          );
        },
        theme: ThemeData(
          primaryColor: primaryColor,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins.toString(),
        ),
        initialRoute: '/splashScreen',
        getPages: AppPages.pageList,
      );
    });
  }
}
