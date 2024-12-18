import 'package:flutter/material.dart';

import '../util/color_set.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({super.key, required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
          color: ColorSet.blackOpacity100,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(15),
        child: Icon(icon,color: ColorSet.blackOpacity300),
      ),
    );
  }
}
