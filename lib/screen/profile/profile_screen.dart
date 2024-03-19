import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/controller/profile_controller.dart';
import 'package:flutter_assessment_ziyad/controller/user_controller.dart';
import 'package:flutter_assessment_ziyad/screen/profile/icon_card_widget.dart';
import 'package:flutter_assessment_ziyad/screen/shared/cart_button_shared.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController u = Get.find();
  ProfileController p = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: const [CardButtonShared()],
      ),
      body: Obx(
        () {
          return ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.all(4.2.w),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 40,
                    child: Icon(
                      p.iconImage ?? PhosphorIcons.cat,
                      color: whiteColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
              profileListBtn(
                  onTap: () {
                    _showDialog(context);
                  },
                  title: 'Change profile picture'),
              profileListBtn(
                  onTap: () {
                    Get.toNamed('/address');
                  },
                  title: 'My Addresses'),
              profileList(
                title: 'ID Number: ${u.userData.value.userid}',
                enabled: false,
              ),
              divider(),
              profileList(
                title: 'Name: ',
                controller: p.nameController,
              ),
              divider(),
              profileList(
                title: 'Email: ',
                controller: p.emailController,
              ),
              divider(),
              profileListDropDown(title: 'Gender: '),
              profileListBtn(
                  onTap: () {
                    p.updateProfileOnClick();
                  },
                  title: p.isChanged.value
                      ? 'Save Changes'
                      : p.isEdit.value
                          ? 'Cancel'
                          : 'Update profile'),
              profileListBtn(
                  visible: p.isChanged.value ? true : false,
                  onTap: () {
                    p.cancelProfileOnClick();
                  },
                  title: 'Cancel'),
              profileListBtn(
                  onTap: () {
                    Get.offNamed('/login');
                    Preference.setBool(Preference.isLogin, false);
                    Preference.remove(Preference.userId);
                  },
                  title: 'Logout'),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.1.w, horizontal: 4.2.w),
                child: Padding(
                  padding: EdgeInsets.all(3.5.w),
                  child: const Center(
                    child: Text(
                      'V.1.5.0 (25)',
                      style: TextStyle(fontSize: 14, color: primaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h)
            ],
          );
        },
      ),
    );
  }

  Widget profileList({
    required String title,
    TextEditingController? controller,
    String? hintText,
    IconData? icon,
    String? errorText,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    bool? enabled,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: primaryColor),
          ),
          Expanded(
            child: TextFormField(
              enabled: enabled ?? true ? p.isEdit.value : false,
              keyboardType: keyboardType,
              controller: controller,
              onChanged: (value) {
                setState(() {
                  p.isChanged.value = true;
                });
              },
              decoration: InputDecoration(
                errorText: errorText,
                border: enabled ?? true
                    ? p.isEdit.value
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        : InputBorder.none
                    : InputBorder.none,
                contentPadding: enabled ?? true
                    ? !p.isEdit.value
                        ? null
                        : EdgeInsets.symmetric(horizontal: 4.2.w)
                    : null,
                hintText: hintText,
                suffixIcon: InkWell(
                  child: Icon(
                    icon,
                    color: primaryColor,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: primaryColor),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      indent: 4.2.w,
      endIndent: 4.2.w,
      color: greyLess,
    );
  }

  Widget profileListBtn(
      {required void Function()? onTap,
      required String title,
      bool? visible = true}) {
    return Visibility(
      visible: visible!,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.1.w, horizontal: 4.2.w),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(2.1.w),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profileListDropDown({
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: primaryColor),
          ),
          DropdownButton<String>(
            hint: p.selectedGender == null ? const Text('Not Set') : null,
            value: p.selectedGender,
            onChanged: !p.isEdit.value
                ? null
                : (newValue) {
                    setState(() {
                      p.selectedGender = newValue!;
                      p.isChanged.value = true;
                    });
                  },
            items: p.gender.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Choose new icon',
            style: TextStyle(fontSize: 16, color: primaryColor),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: p.icons.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    p.updateIconOnClick(p.icons[index].codePoint);
                  },
                  child: IconCard(icon: p.icons[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
