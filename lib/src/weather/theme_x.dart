import 'package:flutter/material.dart';

extension ThemeX on ThemeData {
  bool get light => brightness == Brightness.light;

  TextStyle? get weatherBgTextStyle => textTheme.headlineSmall?.copyWith(
        color: Colors.white,
        fontSize: 20,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(light ? 1 : 0.8),
            offset: const Offset(0, 0),
            blurRadius: light ? 2 : 3,
          ),
        ],
      );
}
