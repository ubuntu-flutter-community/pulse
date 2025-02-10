import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';
import '../weather.dart';
import '../extensions/build_context_x.dart';
import '../l10n/l10n.dart';
import '../weather/weather_model.dart';
import 'side_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedLocales,
      onGenerateTitle: (context) => 'MusicPod',
      debugShowCheckedModeBanner: false,
      theme: yaruLight,
      darkTheme: yaruDark.copyWith(
        tabBarTheme: TabBarTheme.of(context).copyWith(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(
            alpha: 0.8,
          ),
        ),
      ),
      home: const StartPage(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final Future<void> _allReady;

  @override
  void initState() {
    super.initState();
    _allReady = di.allReady();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _allReady,
        builder: (context, snapshot) =>
            snapshot.hasData ? const AppPage() : const LoadingPage(),
      );
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: YaruWindowTitleBar(
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: YaruCircularProgressIndicator(),
        ),
      );
}

class AppPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    di<WeatherModel>().loadWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weatherType = watchPropertyValue((WeatherModel m) => m.weatherType);

    return LayoutBuilder(
      builder: (context, constraints) {
        var list = [
          if (constraints.maxWidth > kBreakPoint) const SideBar(),
          Expanded(
            child: WeatherPage(
              showDrawer: constraints.maxWidth < kBreakPoint,
            ),
          ),
        ];
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: Platform.isMacOS ? (context.light ? 1 : 0.6) : 0.7,
              child: WeatherBg(
                weatherType: weatherType,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
            Row(
              children: Platform.isMacOS ? list.reversed.toList() : list,
            ),
          ],
        );
      },
    );
  }
}
