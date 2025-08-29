import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FadeScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(BuildContext context, Curve? curve, Alignment? alignment, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
  
}
