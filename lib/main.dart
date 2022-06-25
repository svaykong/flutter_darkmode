// import 'dart:developer';
// import 'dart:io' show Platform;

// import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:provider/provider.dart';

import 'notifiers/theme_notifier.dart';
// import 'utils/color_util.dart';

void main() {
  // should call this to prevent error in some case
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (_, theme, __) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: theme.getTheme(),
        home: const MyHomePage(title: 'Flutter DarkMode Toggle'),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    // Platform.isMacOS

    const profileImageUrl =
        '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(children: [
          DrawerHeader(
            child: CircleAvatar(
              radius: 80,
              child: ClipOval(
                child: Image.network(profileImageUrl),
              ),
            ),
          ),
          DayNightSwitcher(
            isDarkModeEnabled: _isDarkModeEnabled,
            onStateChanged: (bool val) {
              if (val) {
                context.read<ThemeNotifier>().setDarkMode();
              } else {
                context.read<ThemeNotifier>().setLightMode();
              }

              setState(() {
                _isDarkModeEnabled = val;
              });
            },
          ),
        ]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Shared Preferences Demo",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
