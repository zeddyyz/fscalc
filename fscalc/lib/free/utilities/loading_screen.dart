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
      return child;
    }
  }
}
