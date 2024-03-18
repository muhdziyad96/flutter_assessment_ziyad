import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:sizer/sizer.dart';

class SharedButton extends StatefulWidget {
  final String title;
  final void Function()? onTap;
  final double? paddingValue;
  final bool isFilled;
  const SharedButton(
      {super.key,
      required this.title,
      this.onTap,
      this.paddingValue,
      required this.isFilled});

  @override
  State<SharedButton> createState() => _SharedButtonState();
}

class _SharedButtonState extends State<SharedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.paddingValue ?? 4.2.w),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: widget.isFilled ? primaryColor : whiteColor,
              border: Border.all(color: primaryColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 18,
                    color: widget.isFilled ? whiteColor : primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
