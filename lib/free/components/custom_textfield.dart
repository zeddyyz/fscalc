import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.containerHeight,
    this.containerWidth,
    this.containerMargin,
    this.containerDecoration,
    this.textFieldStyle,
    this.cursorColor,
    this.inputDecoration,
    @required this.hintText,
    this.hintTextColor,
    this.contentPadding,
    @required this.prefixIcon,
    this.onChanged,
    this.controller,
    this.numberKeyboard = true,
  }) : super(key: key);

  final double? containerHeight;
  final double? containerWidth;
  final EdgeInsets? containerMargin;
  final Decoration? containerDecoration;
  final TextStyle? textFieldStyle;
  final Color? cursorColor;
  final InputDecoration? inputDecoration;
  final String? hintText;
  final Color? hintTextColor;
  final EdgeInsets? contentPadding;
  final IconData? prefixIcon;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool numberKeyboard;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight ?? 60,
      width: containerWidth ?? screenWidth * 0.9,
      margin: containerMargin ??
          const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: containerDecoration ??
          BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(12),
          ),
      child: TextField(
        controller: controller,
        style: textFieldStyle ?? const TextStyle(color: kBlack),
        cursorColor: cursorColor ?? kBlack,
        keyboardType: numberKeyboard
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        decoration: inputDecoration ??
            InputDecoration(
              hintStyle: TextStyle(
                color: hintTextColor ?? kBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              hintText: hintText,
              border: InputBorder.none,
              contentPadding:
                  contentPadding ?? const EdgeInsets.only(top: 20, left: 24),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12, right: 8),
                child: Icon(
                  prefixIcon,
                  size: 28,
                  color: kThemeRed,
                ),
              ),
            ),
        onChanged: onChanged,
      ),
    );
  }
}
