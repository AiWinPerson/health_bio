import 'package:flutter/material.dart';

import '../util/color_set.dart';

class TextNavigationButton extends StatelessWidget {
  const TextNavigationButton({super.key, required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorSet.violet500,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
        ),
        onPressed: onPressed, child: SizedBox(
        height: 40,
        width: double.maxFinite,
        child: Center(child: Text(title,style: const TextStyle(color: ColorSet.white),))
    )
    );
  }
}
