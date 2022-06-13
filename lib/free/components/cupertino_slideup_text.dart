import 'package:flutter/material.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/utilities/constants.dart';

class CupertinoSlideUpTitle extends StatelessWidget {
  const CupertinoSlideUpTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              foreground: Paint()..shader = termsTitle,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16, top: 4),
            child: CupertinoCloseIcon(),
          ),
        ],
      ),
    );
  }
}
