import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class CupertinoCloseIcon extends StatelessWidget {
  const CupertinoCloseIcon({
    Key? key,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 29,
        width: 29,
        decoration: BoxDecoration(
          color: backgroundColor ??
              CupertinoColors.lightBackgroundGray.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.close_rounded,
            color: iconColor ?? kDarkGrey,
            size: 19,
          ),
        ),
      ),
    );
  }
}
