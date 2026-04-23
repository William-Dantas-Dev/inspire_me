import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../application/startup/app_startup_provider.dart';
import '../../../application/startup/app_startup_state.dart';
import '../../../data/quotes/models/quote_model.dart';
import '../../../data/quotes/providers/quotes_provider.dart';
import '../../../data/services/notification_preferences_service.dart';
import '../../../data/services/notification_service.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _processedNotifications = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(appStartupProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final startupState = ref.watch(appStartupProvider);
    final quotesAsync = ref.watch(quotesProvider);

    ref.listen<AppStartupState>(appStartupProvider, (previous, next) {
      if (!mounted) return;

      if (next.status == AppStartupStatus.ready) {
        print('🚀 App Ready');
        // TODO NAVIGATE TO HOME
      }

      if (next.status == AppStartupStatus.error) {
        print('❌ Startup Error: ${next.errorMessage}');
      }
    });

    ref.listen<AsyncValue<List<QuoteModel>>>(quotesProvider, (previous, next) {
      next.when(
        data: (quotes) async {
          if (quotes.isEmpty || _processedNotifications) return;

          _processedNotifications = true;

          final messages = quotes.map((quote) => quote.text).toList();
          final prefs = ref.read(sharedPreferencesProvider);
          final notificationPreferences = NotificationPreferencesService(prefs);

          await NotificationService.instance.replenishQueue(
            title: l10n.appName,
            messages: messages,
            preferences: notificationPreferences,
            targetCount: 20,
            intervalHours: 3,
          );

          final pendingCount = await NotificationService.instance
              .getPendingCount();

          print('⏰ Notification queue replenished');
          print('📌 Pending notifications: $pendingCount');
        },
        loading: () {},
        error: (error, stackTrace) {
          print('❌ Quotes Error: $error');
        },
      );
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.surface, colorScheme.surfaceContainerHighest],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.20),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 52,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.appName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.splashSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.80),
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _buildStatusText(
                    l10n: l10n,
                    startupState: startupState,
                    quotesAsync: quotesAsync,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildStatusText({
    required AppLocalizations l10n,
    required AppStartupState startupState,
    required AsyncValue<List<QuoteModel>> quotesAsync,
  }) {
    if (startupState.status == AppStartupStatus.error) {
      return startupState.errorMessage ?? 'Startup error';
    }

    return quotesAsync.when(
      data: (quotes) => 'Quotes loading...',
      loading: () => l10n.loading,
      error: (error, stackTrace) => 'Quotes error: $error',
    );
  }
}
