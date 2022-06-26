import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'notifiers/theme_notifier.dart';
import 'pages/page.dart';

void main() {
  // should call this to prevent error in some case
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const RootApp(),
    ),
  );
}


