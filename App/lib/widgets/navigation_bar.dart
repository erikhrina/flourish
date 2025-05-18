import 'package:flourish/pages/my_plants/my_plants_page.dart';
import 'package:flourish/pages/scanner/scanner_page.dart';
import 'package:flourish/pages/search/search_page.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class NavigationBarWrapper extends StatelessWidget {
  final String currentPage;

  const NavigationBarWrapper(this.currentPage, {super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'myPlants': const MyPlantsPage(),
      'scanner': const ScannerPage(),
      'search': const SearchPage(),
    };
    final currentIndex = tabs.keys.toList().indexOf(currentPage);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) async {
        if (currentIndex != i) {
          await Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a1, a2) => tabs.values.elementAt(i),
              transitionDuration: Duration.zero,
            ),
          );
        }
      },
      backgroundColor: AppTheme.of(context).primary,
      selectedItemColor: Color(0xFFFFFFFF),
      unselectedItemColor: Color(0xFFFFFFFF),
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 12.0,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      iconSize: 24,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 24),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(MingCute.flowerpot_line),
          label: 'My Plants',
        ),
        BottomNavigationBarItem(
          icon: const Icon(MingCute.scan_line),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: const Icon(MingCute.search_line),
          label: 'Search',
        ),
      ],
    );
  }
}
