import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'app/app.dart';
import 'register_dependencies.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  registerDependencies();

  runApp(const App());
}
