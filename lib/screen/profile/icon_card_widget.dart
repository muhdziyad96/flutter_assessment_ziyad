import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final IconData icon;

  const IconCard({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Icon(
          icon,
          size: 32.0,
        ),
      ),
    );
  }
}
