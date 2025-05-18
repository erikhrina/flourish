import 'package:flourish/main.dart';
import 'package:flourish/services/objectbox_service.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flourish/widgets/generic_list.dart';
import 'package:flourish/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';

class MyPlantsPage extends StatefulWidget {
  const MyPlantsPage({super.key});

  @override
  State<MyPlantsPage> createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Plants',
                    style: AppTheme.of(context).titleLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      MyApp.of(context).setThemeMode(
                        AppTheme.themeMode == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark,
                      );
                    },
                    icon: Icon(
                      AppTheme.themeMode == ThemeMode.dark
                          ? MingCute.sun_line
                          : MingCute.moon_line,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GenericList(
                  GetIt.instance<ObjectboxService>().getPlants(),
                  onTap: (_) {},
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWrapper('myPlants'),
    );
  }
}
