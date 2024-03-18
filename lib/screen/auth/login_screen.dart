import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/controller/home_controller.dart';
import 'package:flutter_assessment_ziyad/controller/user_controller.dart';
import 'package:flutter_assessment_ziyad/helper/sql_helper.dart';
import 'package:flutter_assessment_ziyad/screen/shared/button_shared.dart';
import 'package:flutter_assessment_ziyad/screen/shared/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool englishLang = true;
  bool malayLang = false;
  HomeController h = Get.find();
  UserController u = Get.find();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> loginUser(String email, String password) async {
    Map<String, dynamic>? user =
        await DatabaseHelper.instance.getUserLogin(email, password);
    if (user?['email'] == email && user?['password'] == password) {
      return true;
    }
    return false;
  }

  showLoaderDialog() {
    var alert = const LoadingDialog();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void loginBtn(BuildContext context, [bool mounted = true]) async {
    bool isLoggedIn =
        await loginUser(_emailController.text, _passwordController.text);
    if (isLoggedIn) {
      showLoaderDialog();
      await u
          .loginUsers(_emailController.text, _passwordController.text)
          .then((value) {
        Get.offNamed('/home')?.then((value) {
          h.changeTabIndex(0);
        });
      });
    } else {
      Get.snackbar(
        'Error',
        'Password is wrong or Email address not exist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        borderRadius: 8,
        margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.23.h),
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'EazyMart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                txtField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  icon: Icons.mail,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email Address is required';
                    }
                    return null;
                  },
                ),
                txtField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _isObscure,
                  icon:
                      _isObscure ? PhosphorIcons.eyeClosed : PhosphorIcons.eye,
                  onTap: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                signInBtn(context),
                noAccount(),
                socialIcon(),
                languageSelection(),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget signInBtn(BuildContext context) {
    return SharedButton(
      title: isLoading ? 'Loading' : 'Sign In',
      onTap: isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                loginBtn(context);
              }
            },
      isFilled: true,
    );
  }

  Widget socialIcon() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              PhosphorIcons.instagramLogoBold,
              color: blackColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              PhosphorIcons.facebookLogoBold,
              color: blackColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              PhosphorIcons.twitterLogoBold,
              color: blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget languageSelection() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return languageDialog();
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(4.2.w),
        child: Column(
          children: [
            const Text('Language'),
            SizedBox(
              height: 1.2.h,
            ),
            const Icon(Icons.language),
          ],
        ),
      ),
    );
  }

  Widget languageDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 6.4.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(color: whiteColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: whiteColor),
                ),
              ],
            ),
          ),
          CheckboxListTile(
            title: const Text('English'),
            activeColor: primaryColor,
            value: englishLang,
            onChanged: (newValue) {
              setState(() {
                englishLang = true;
                malayLang = false;
              });
              Navigator.pop(context);
            },
          ),
          CheckboxListTile(
            title: const Text('Bahasa Malaysia'),
            activeColor: primaryColor,
            value: malayLang,
            onChanged: (newValue) {
              setState(() {
                malayLang = true;
                englishLang = false;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget noAccount() {
    return Padding(
      padding: EdgeInsets.all(2.1.w),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Dont have an account ? ',
            ),
            TextSpan(
                text: 'Sign Up !',
                style: const TextStyle(
                    color: Color.fromARGB(255, 34, 84, 171),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed('/signUp')?.then((value) {
                      value
                          ? Get.snackbar(
                              'Success',
                              'Email address is successfull register',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              borderRadius: 8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.2.w, vertical: 1.23.h),
                              duration: const Duration(seconds: 3),
                            )
                          : null;
                    });
                  })
          ],
        ),
      ),
    );
  }
}
