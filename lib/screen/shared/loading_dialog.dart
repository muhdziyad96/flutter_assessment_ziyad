import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:sizer/sizer.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(4.2.w),
            child: const CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(4.2.w), child: const Text("Loading...")),
        ],
      ),
    );
  }
}

showLoaderDialog(BuildContext context) {
  var alert = const AlertDialog();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
