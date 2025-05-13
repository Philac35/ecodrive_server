import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color quaternary;

  CustomColors({required this.quaternary});

  @override
  ThemeExtension<CustomColors> copyWith({Color? quaternary}) {
    return CustomColors(
      quaternary: quaternary ?? this.quaternary,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      quaternary: Color.lerp(quaternary, other.quaternary, t)!,
    );
  }
}
