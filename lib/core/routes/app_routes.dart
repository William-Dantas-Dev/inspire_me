import 'package:flutter/material.dart';
import '../../features/presentation/pages/home/home_page.dart';
import '../../features/presentation/pages/favorites/favorites_page.dart';
import '../../features/presentation/pages/settings/settings_page.dart';
import '../../features/presentation/pages/splash/splash_page.dart';
import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case RouteNames.favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesPage(),
          settings: settings,
        );
      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
          settings: settings,
        );
    }
  }
}
