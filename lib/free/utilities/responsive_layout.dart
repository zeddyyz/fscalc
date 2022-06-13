import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.isMobile,
    required this.isTablet,
  }) : super(key: key);
  final Widget isMobile;
  final Widget isTablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (GetPlatform.isMobile) {
          return isMobile;
        } else if (context.isTablet) {
          return isTablet;
        }
        return Container();
      },
    );
  }
}
