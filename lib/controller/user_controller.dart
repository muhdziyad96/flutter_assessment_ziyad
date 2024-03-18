import 'package:flutter_assessment_ziyad/controller/profile_controller.dart';
import 'package:flutter_assessment_ziyad/helper/sql_helper.dart';
import 'package:flutter_assessment_ziyad/model/user_model.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sqflite/sqflite.dart';

class UserController extends GetxController {
  var userData = User().obs;

  void setUserData(Rx<User> userData) {
    this.userData = userData;
    update();
  }

  Future<void> loginUsers(String email, String password) async {
    Database db = await DatabaseHelper.instance.database;
    var user = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    userData.value = User.fromMap(user[0]);
    Preference.setString(Preference.userId, userData.value.userid!.toString());
    Preference.setBool(Preference.isLogin, true);
    setUserData(userData);
    ProfileController p = Get.put(ProfileController());
    p.getTextController(
        name: userData.value.name ?? 'Not Set',
        email: userData.value.email ?? 'Not Set',
        gender: userData.value.gender ?? 'Not Set');
    p.getIcon(
        image: userData.value.image ?? PhosphorIcons.cat.codePoint.toString());
    update();
  }

  Future<void> getUsers() async {
    String? userId = Preference.getString(Preference.userId);
    Database db = await DatabaseHelper.instance.database;
    var user = await db.query(
      'users',
      where: 'userid = ?',
      whereArgs: [userId],
      limit: 1,
    );

    userData.value = User.fromMap(user[0]);
    Preference.setString(Preference.userId, userData.value.userid!.toString());
    setUserData(userData);
    ProfileController p = Get.put(ProfileController());
    p.getTextController(
        name: userData.value.name ?? 'Not Set',
        email: userData.value.email ?? 'Not Set',
        gender: userData.value.gender ?? 'Not Set');
    p.getIcon(
        image: userData.value.image ?? PhosphorIcons.cat.codePoint.toString());
    update();
  }
}
