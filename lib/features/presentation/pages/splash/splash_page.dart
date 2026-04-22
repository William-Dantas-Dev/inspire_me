import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../application/startup/app_startup_provider.dart';
import '../../../application/startup/app_startup_state.dart';
import '../../../data/quotes/models/quote_model.dart';
import '../../../data/quotes/providers/quotes_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _printedRandomQuote = false;

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
      }

      if (next.status == AppStartupStatus.error) {
        print('❌ Startup Error: ${next.errorMessage}');
      }
    });

    ref.listen<AsyncValue<List<QuoteModel>>>(quotesProvider, (previous, next) {
      next.when(
        data: (quotes) {
          print('✅ Quotes loaded: ${quotes.length}');

          if (quotes.isEmpty) {
            print('⚠️ Quotes list is empty');
            return;
          }

          if (_printedRandomQuote) return;
          _printedRandomQuote = true;

          final shuffled = [...quotes]..shuffle();
          final randomQuote = shuffled.first;

          print('🎯 Random Quote: ${randomQuote.text}');
        },
        loading: () {
          print('⏳ Loading quotes...');
        },
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
      data: (quotes) => 'Quotes loaded: ${quotes.length}',
      loading: () => l10n.loading,
      error: (error, stackTrace) => 'Quotes error: $error',
    );
  }
}
