import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:updater/updater.dart' as updater;
import 'package:xenon_cp/updaters.dart';
import 'package:xenon_cp/views/home/home_page.dart';
import 'package:xenon_cp/views/settings/theme.dart';

class XenonCPApp extends StatelessWidget {
  const XenonCPApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Obx(
      // updater: ThemeUpdater(
      //   initialState: ThemeMode.dark,
      //   updateForCurrentEvent: true,
      // ),
      // update: (context, state) {
      () {
        if (themeChange.value == 0) false;
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xenon-Base Controle Panel',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            // scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: AppBarTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.purple,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.purple,
              // secondary: Colors.white70,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.purple,
            // scaffoldBackgroundColor: Colors.black87,
            colorScheme: const ColorScheme.dark(
              primary: Colors.purple,
              // secondary: Colors.black54,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.purple,
            ),
          ),
          themeMode: themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}
