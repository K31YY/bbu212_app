import 'package:bbu212_app/app_colors.dart';
import 'package:bbu212_app/login_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.white
    ..backgroundColor = AppColors.bgColor
    ..indicatorColor = AppColors.white
    ..textColor = AppColors.white
    ..maskColor = AppColors.bgColor.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTB212 App',
      home: const LoginUser(), // startup screen, launcher screen
      builder: EasyLoading.init(),
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgColor,
          titleTextStyle: TextStyle(color: AppColors.white, fontSize: 18),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(color: AppColors.white),
        ),
      ),
    );
  }
}
// Widget (UI Components):
// 1) Stateless Widget
// 2) Stateful Widget

// Material Design (Android)
// Cupertino Design (iOS)
