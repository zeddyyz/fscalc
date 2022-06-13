import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward()
          ..addListener(() {
            if (controller.isCompleted && mounted) {
              setState(() {
                controller.repeat();
              });
            }
          });

    animation = Tween(begin: 0.0, end: pi).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: animation.value,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kThemeRed),
                  borderRadius: BorderRadius.circular(8),
                  color: kThemeRed,
                ),
                height: 120,
                width: 120,
              ),
            );
          },
        ),
      ),
    );
  }
}
