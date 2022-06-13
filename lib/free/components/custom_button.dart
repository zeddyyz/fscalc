import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.width,
    this.height,
    this.buttonColor,
    @required this.title,
    this.textColor,
    this.textSize,
    this.fontWeight = FontWeight.w500,
    @required this.onTap,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? buttonColor;
  @required
  final String? title;
  final Color? textColor;
  final double? textSize;
  final FontWeight? fontWeight;
  @required
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width ?? screenWidth * 0.9,
        height: height ?? 48,
        decoration: BoxDecoration(
          color: buttonColor ?? kThemeRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title.toString(),
            style: TextStyle(
              color: textColor ?? kWhite,
              fontWeight: fontWeight,
              fontSize: textSize ?? 18,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
