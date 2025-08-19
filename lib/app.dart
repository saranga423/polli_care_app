import 'package:cinec_movie_booking/features/authentication/screens/onboarding/onboarding.dart';
import 'package:cinec_movie_booking/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/authentication/screens/admin/admin_dashboard.dart';
import 'features/authentication/screens/home_screen/home_screen.dart';
import 'features/authentication/screens/login/login.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      darkTheme: CAppTheme.darkTheme,
      initialRoute: '/onboarding',
      getPages: [
        GetPage(name: '/onboarding', page: () => const OnBoardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(
          name: '/admin_dashboard',
          page: () => const AdminDashboardScreen(),
        ),
      ],
    );
  }
}
