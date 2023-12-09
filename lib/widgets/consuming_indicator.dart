import 'package:flutter/material.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';

Widget linearFillIndicator(int currentStep) {
  return StepProgressIndicator(
    totalSteps: 100,
    currentStep: currentStep,
    size: 10,
    padding: 0,
    selectedColor: Colors.yellow,
    unselectedColor: Colors.cyan,
    roundedEdges: const Radius.circular(10),
    selectedGradientColor: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.green, Color.fromARGB(255, 0, 255, 8)],
    ),
    unselectedGradientColor: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.grey, Colors.grey],
    ),
  );
}
