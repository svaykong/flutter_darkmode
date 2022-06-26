import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifiers/theme_notifier.dart';
import '../utils/extension_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkModeEnabled = false;

  Future<Map<String, String>> _loadEnv() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      // load dotenv
      await dotenv.load();
    });

    return dotenv.env;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: _getDrawer(),
      body: _getBody(),
    );
  }

  Widget _getDataFromENV() {
    return FutureBuilder<Map<String, String>>(
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
    );
  }

  Widget _getDataFromStorage() {
    return const CircleAvatar(
      radius: 80,
      child: ClipOval(
        child: Icon(
          Icons.person,
          size: 48,
        ), //Image.network(profileURL),
      ),
    );
  }

  Widget _getDrawer() {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
          child: _getDataFromStorage(),
        ),
        Consumer<ThemeNotifier>(
          builder: ((_, theme, __) => DayNightSwitcher(
                isDarkModeEnabled: theme.getTheme() == ThemeData.dark(),
                onStateChanged: (bool val) {
                  setState(() {
                    _isDarkModeEnabled = val;
                  });
                  if (val) {
                    context.read<ThemeNotifier>().setDarkMode();
                  } else {
                    context.read<ThemeNotifier>().setLightMode();
                  }
                },
              )),
        ),
      ]),
    );
  }

  Widget _getBody() {
    return Center(
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
    );
  }
}
