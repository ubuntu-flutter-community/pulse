import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get light => theme.brightness == Brightness.light;
  MediaQueryData get mq => MediaQuery.of(this);
}
