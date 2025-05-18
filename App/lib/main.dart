import 'package:flourish/pages/my_plants/my_plants_page.dart';
import 'package:flourish/services/objectbox_service.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final _getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.initialize();

  ObjectboxService objectboxService = await ObjectboxService().create();
  _getIt.registerSingleton<ObjectboxService>(objectboxService);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = AppTheme.themeMode;

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        AppTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flourish',
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.of(context).primary,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: AppTheme.of(context).primary,
          unselectedLabelColor: AppTheme.of(context).primaryText,
          labelStyle: AppTheme.of(context).titleMedium,
          unselectedLabelStyle: AppTheme.of(context).titleMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: AppTheme.of(context).primary,
        ),
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.of(context).primary,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: const Color(0xFFFFFFFF),
          unselectedLabelColor: const Color(0xFFFFFFFF),
          labelStyle: AppTheme.of(context).titleMedium,
          unselectedLabelStyle: AppTheme.of(context).titleMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: const Color(0xFFFFFFFF),
        ),
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      home: WillPopScope(
        onWillPop: () async => false,
        child: const MyPlantsPage(),
      ),
      themeMode: _themeMode,
    );
  }
}
