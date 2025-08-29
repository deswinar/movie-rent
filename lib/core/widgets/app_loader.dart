import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final String asset;
  final bool repeat;

  const AppLoader({
    super.key,
    this.size = 120,
    this.asset = 'assets/animations/lottie/lovely-cats.json',
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Lottie.asset(
          asset,
          fit: BoxFit.contain,
          repeat: repeat,
        ),
      ),
    );
  }
}
