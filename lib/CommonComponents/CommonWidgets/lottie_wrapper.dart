
// Wrapper for Lottie animations
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final double size;
  final String asset;
  final bool center;

  const LottieLoader({
    super.key,
    this.asset = 'assets/lottie/loading.json',
    this.size = 120,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Lottie.asset(asset, width: size, height: size);

    return center ? Center(child: widget) : widget;
  }
}
