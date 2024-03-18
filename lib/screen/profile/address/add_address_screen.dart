import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/screen/shared/button_shared.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  Future<List?> getAddresses() async {
    List<String>? encodedAddresses = Preference.getStringList('address');
    if (encodedAddresses != null) {
      return encodedAddresses
          .map((encodedAddress) => json.decode(encodedAddress))
          .toList();
    } else {
      return null;
    }
  }

  Future<void> saveAddress(Map<String, dynamic> address) async {
    List addresses = await getAddresses() ?? [];
    addresses.add(address);
    List<String> encodedAddresses =
        addresses.map((address) => json.encode(address)).toList();
    await Preference.setStringList('address', encodedAddresses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
      ),
      body: Column(
        children: [
          txtField(
            labelText: 'Name',
            controller: _nameController,
            hintText: 'Rumah Sewa',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          txtField(
            labelText: 'Address',
            controller: _addressController,
            hintText: '123, Jalan Kebun Raya, Taman Sembilu Kasih',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
          txtField(
            labelText: 'City',
            controller: _cityController,
            hintText: 'Subang Jaya',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'City is required';
              }
              return null;
            },
          ),
          txtField(
            labelText: 'Postcode',
            controller: _postcodeController,
            hintText: '68100',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Postcode is required';
              }
              return null;
            },
          ),
          txtField(
            labelText: 'State',
            controller: _stateController,
            hintText: 'Selangor',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'State is required';
              }
              return null;
            },
          ),
          SharedButton(
            title: 'Save Address',
            isFilled: true,
            onTap: () async {
              List addresses = await getAddresses() ?? [];
              Map<String, dynamic> addressData = {
                'id': Random().nextInt(100000) + 1,
                'name': _nameController.text,
                'address': _addressController.text,
                'city': _cityController.text,
                'postcode': _postcodeController.text,
                'state': _stateController.text,
                'isDefault': addresses == [] ? true : false
              };
              await saveAddress(addressData).then((value) => Get.back());
            },
          )
        ],
      ),
    );
  }
}

Widget txtField({
  TextEditingController? controller,
  String? labelText,
  String? hintText,
  IconData? icon,
  bool? obscureText,
  String? errorText,
  TextInputType? keyboardType,
  void Function()? onTap,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.23.h),
        padding: EdgeInsets.only(left: 4.2.w),
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          minLines: 1,
          maxLines: 5,
          onChanged: onChanged ?? (String value) {},
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
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
      ),
    ],
  );
}
