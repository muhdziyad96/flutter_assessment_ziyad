import 'package:flutter/material.dart';

const primaryColor = Colors.red;
const blackColor = Colors.black;
const whiteColor = Colors.white;
const greyLess = Color(0xFFA09D9D);

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
