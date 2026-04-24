import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../application/startup/app_startup_provider.dart';
import '../../../application/startup/app_startup_state.dart';
import '../../../data/notifications/models/notification_settings_service.dart';
import '../../../data/quotes/models/quote_model.dart';
import '../../../data/quotes/providers/quotes_provider.dart';
import '../../../data/services/notification_preferences_service.dart';
import '../../../data/services/notification_service.dart';
import './widgets/splash_background.dart';
import './widgets/splash_brand_section.dart';
import './widgets/splash_loading_section.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _processedNotifications = false;
  bool _startupReady = false;
  bool _notificationsHandled = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(appStartupProvider.notifier).initialize();
    });
  }

  void _goToHomeIfReady() {
    if (!mounted) return;
    if (_navigated) return;
    if (!_startupReady) return;
    if (!_notificationsHandled) return;

    _navigated = true;

    Navigator.pushNamed(context, RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final startupState = ref.watch(appStartupProvider);
    final quotesAsync = ref.watch(quotesProvider);

    ref.listen<AppStartupState>(appStartupProvider, (previous, next) {
      if (!mounted) return;

      if (next.status == AppStartupStatus.ready) {
        _startupReady = true;
        _goToHomeIfReady();
      }

    });

    ref.listen<AsyncValue<List<QuoteModel>>>(quotesProvider, (previous, next) {
      next.when(
        data: (quotes) async {
          if (_processedNotifications) return;

          _processedNotifications = true;

          final prefs = ref.read(sharedPreferencesProvider);
          final notificationPreferences = NotificationPreferencesService(prefs);
          final notificationSettingsService = NotificationSettingsService(
            prefs,
          );
          final notificationSettings = notificationSettingsService
              .loadSettings();

          if (!notificationSettings.enabled) {
            _notificationsHandled = true;
            _goToHomeIfReady();
            return;
          }

          if (quotes.isEmpty) {
            _notificationsHandled = true;
            _goToHomeIfReady();
            return;
          }

          final messages = quotes.map((quote) => quote.text).toList();

          await NotificationService.instance.replenishQueue(
            title: l10n.appName,
            messages: messages,
            preferences: notificationPreferences,
            settings: notificationSettings,
            targetCount: 20,
            intervalHours: 3,
          );
          _notificationsHandled = true;
          _goToHomeIfReady();
        },
        loading: () {},
        error: (error, stackTrace) {
          _notificationsHandled = true;
          _goToHomeIfReady();
        },
      );
    });

    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                SplashBrandSection(
                  appName: l10n.appName,
                  subtitle: l10n.splashSubtitle,
                ),
                const Spacer(),
                SplashLoadingSection(
                  statusText: _statusText(l10n, startupState, quotesAsync),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusText(
    AppLocalizations l10n,
    AppStartupState startupState,
    AsyncValue<List<QuoteModel>> quotesAsync,
  ) {
    if (startupState.status == AppStartupStatus.error) {
      return startupState.errorMessage ?? 'Startup error';
    }

    return quotesAsync.when(
      data: (_) => l10n.loading,
      loading: () => l10n.loading,
      error: (error, _) => 'Quotes error: $error',
    );
  }
}
