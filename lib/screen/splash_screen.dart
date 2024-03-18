import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogin = Preference.getBool(Preference.isLogin)!;
  bool showOnboard = Preference.getBool(Preference.showOnboard)!;
  String? version;
  String? backendVersion;

  redirectPage(int duration) {
    Timer(Duration(seconds: duration), () {
      showOnboard
          ? Get.offNamed('/welcome')
          : isLogin
              ? Get.offNamed('/home')
              : Get.offNamed('/login');
    });
  }

  onLoading() async {
    redirectPage(1);
  }

  @override
  void initState() {
    super.initState();
    onLoading();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: LinearProgressIndicator(
                color: primaryColor,
                backgroundColor: whiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
