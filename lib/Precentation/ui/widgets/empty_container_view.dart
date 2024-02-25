import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyContainerView extends StatelessWidget {
  const EmptyContainerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/empty_animation.json');
  }
}
