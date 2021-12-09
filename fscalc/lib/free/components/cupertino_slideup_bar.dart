import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSlideUpBar extends StatelessWidget {
  const CupertinoSlideUpBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4.5,
        decoration: BoxDecoration(
          color: CupertinoColors.inactiveGray.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
