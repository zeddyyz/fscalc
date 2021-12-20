import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

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
        if (Device.get().isPhone) {
          return isMobile;
        } else if (Device.get().isTablet) {
          return isTablet;
        }
        return Container();
      },
    );
  }
}
