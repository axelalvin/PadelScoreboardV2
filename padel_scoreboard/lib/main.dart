import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Padel Scoreboard');
    setWindowMaxSize(const Size(768, 1024));
    setWindowMinSize(const Size(600, 800));
  }

  runApp(const App());
}
