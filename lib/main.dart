import 'dart:developer' as dev_tool show log;

import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'notifiers/theme_notifier.dart';

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

extension Log on Object {
  void log(message) {
    dev_tool.log(message.toString());
  }
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

  Future<Map<String, String>> _loadEnv() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      // load dotenv
      await dotenv.load();
    });

    return dotenv.env;
  }

  @override
  void initState() {
    super.initState();

    _isDarkModeEnabled = context.read<ThemeNotifier>().getDarkModePres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(children: [
          DrawerHeader(
            child: FutureBuilder<Map<String, String>>(
              future: _loadEnv(),
              builder: (context, AsyncSnapshot<Map<String, String>?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error::${snapshot.error}",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    } else if (snapshot.hasData == false) {
                      return Center(
                        child: Text(
                          "No data",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    }
                    final profileURL = snapshot.data!["PROFILE_URL"];
                    if (profileURL == null) {
                      return Center(
                        child: Text(
                          "No data",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                        child: Image.network(profileURL),
                      ),
                    );
                }
              },
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
