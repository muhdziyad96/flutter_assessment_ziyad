import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/helper/sql_helper.dart';
import 'package:flutter_assessment_ziyad/model/user_model.dart';
import 'package:flutter_assessment_ziyad/screen/shared/button_shared.dart';
import 'package:flutter_assessment_ziyad/screen/shared/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValidEmail = true;
  bool _isValidPassword = true;
  bool _isObscure = true;

  Future<bool> checkUser(String email, String password) async {
    Map<String, dynamic>? user =
        await DatabaseHelper.instance.getUserLogin(email, password);
    if (user?['email'] == email && user?['password'] == password) {
      return true;
    }
    return false;
  }

  void _validateEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isValid = emailRegex.hasMatch(email);
    setState(() {
      _isValidEmail = isValid;
    });
  }

  void _validatePassword(String password) {
    RegExp passwordRegex = RegExp(r'^.{8,}$');
    bool isValid = passwordRegex.hasMatch(password);
    setState(() {
      _isValidPassword = isValid;
    });
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded)),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    txtField(
                      controller: _nameController,
                      hintText: 'John Doe',
                      icon: PhosphorIcons.user,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    txtField(
                      controller: _emailController,
                      hintText: 'example@email.com',
                      icon: Icons.mail,
                      keyboardType: TextInputType.text,
                      errorText: _isValidEmail ? null : 'Invalid Email Address',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Address is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _validateEmail(value);
                      },
                    ),
                    txtField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: _isObscure
                          ? PhosphorIcons.eyeClosed
                          : PhosphorIcons.eye,
                      onTap: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      obscureText: _isObscure,
                      keyboardType: TextInputType.text,
                      errorText: _isValidPassword ? null : 'Invalid Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _validatePassword(value);
                      },
                    ),
                    signInBtn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget txtField({
    TextEditingController? controller,
    String? hintText,
    IconData? icon,
    bool? obscureText,
    String? errorText,
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
          errorText: errorText,
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

  Widget signInBtn() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          bool isLoggedIn =
              await checkUser(_emailController.text, _passwordController.text);
          if (isLoggedIn) {
            Get.snackbar(
              'Error',
              'Email Address is already existed',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              borderRadius: 8,
              margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.23.h),
              duration: const Duration(seconds: 3),
            );
          } else {
            showLoaderDialog;
            final newUser = User(
                userid: Random().nextInt(100000) + 1,
                name: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text);

            await DatabaseHelper.instance.add(newUser).then((value) async {
              Navigator.pop(context, true);
            });
          }
        }
      },
      child: const SharedButton(
        title: 'Sign Up',
        isFilled: true,
      ),
    );
  }
}
