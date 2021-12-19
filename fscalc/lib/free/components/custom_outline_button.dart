import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key? key,
    this.width,
    required this.backgroundColor,
    required this.outlineBorderColor,
    required this.title,
    required this.titleColor,
    required this.titleFontWeight,
    required this.onTap,
  }) : super(key: key);

  final double? width;
  final Color backgroundColor;
  final Color outlineBorderColor;
  final String title;
  final Color titleColor;
  final FontWeight titleFontWeight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width ?? double.maxFinite,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: outlineBorderColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: titleFontWeight,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
