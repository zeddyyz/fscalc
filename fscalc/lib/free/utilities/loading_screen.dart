import 'package:flutter/material.dart';
import 'package:fscalc/free/components/loading.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key? key,
    required this.loading,
    required this.child,
  }) : super(key: key);

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else {
      return AnimatedOpacity(
        opacity: !loading ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 5000),
        child: child,
      );
    }
  }
}
