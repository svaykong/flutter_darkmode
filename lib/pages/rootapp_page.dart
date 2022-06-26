import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../notifiers/theme_notifier.dart';
import 'page.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (_, theme, __) => MaterialApp(
        title: 'Flutter Demo',
        theme: theme.getTheme(),
        home: const HomePage(title: 'Flutter DarkMode Toggle'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
