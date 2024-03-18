import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/controller/user_controller.dart';
import 'package:flutter_assessment_ziyad/helper/sql_helper.dart';
import 'package:flutter_assessment_ziyad/model/user_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isEdit = false.obs;
  RxBool isChanged = false.obs;
  UserController u = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  IconData? iconImage;
  String? selectedGender;

  final List<IconData> icons = [
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.accessibility,
    Icons.account_balance,
    Icons.account_circle,
    Icons.airplanemode_active,
    Icons.android,
    Icons.attach_file,
    Icons.audiotrack,
    Icons.beach_access,
    Icons.cake,
    Icons.camera,
    Icons.car_rental,
    Icons.cloud,
    Icons.desktop_mac,
    Icons.email,
    Icons.favorite,
    Icons.fastfood,
    Icons.local_florist,
    Icons.mic,
  ];

  List<String> gender = [
    'Male',
    'Female',
  ];

  getIcon({
    required String image,
  }) async {
    iconImage = IconData(int.parse(image), fontFamily: 'MaterialIcons');
    update();
  }

  getTextController(
      {required String name,
      required String email,
      required String gender}) async {
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    genderController = TextEditingController(text: gender);
    selectedGender = gender == 'Not Set' ? null : gender;
    update();
  }

  updateProfileOnClick() async {
    isChanged.value
        ? await DatabaseHelper.instance
            .update(
              User(
                userid: u.userData.value.userid!,
                name: nameController.text,
                password: u.userData.value.password!,
                email: emailController.text,
                gender: selectedGender,
                image: iconImage?.codePoint.toString(),
              ),
            )
            .then((value) => u.getUsers())
            .then((value) {
            isEdit.value = false;
            isChanged.value = false;
          })
        : isEdit.value = !isEdit.value;
    update();
  }

  cancelProfileOnClick() {
    isEdit.value = false;
    isChanged.value = false;
    getTextController(
        name: u.userData.value.name!,
        email: u.userData.value.email ?? 'Not Set',
        gender: u.userData.value.gender ?? 'Not Set');
    update();
  }

  updateIconOnClick(int iconData) async {
    await DatabaseHelper.instance
        .update(
      User(
        userid: u.userData.value.userid!,
        name: nameController.text,
        password: u.userData.value.password!,
        email: emailController.text,
        gender: selectedGender,
        image: iconData.toString(),
      ),
    )
        .then((value) {
      u.getUsers();
      Get.back();
    });
    update();
  }
}
