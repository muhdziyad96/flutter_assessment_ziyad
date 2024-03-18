import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/screen/home/nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
