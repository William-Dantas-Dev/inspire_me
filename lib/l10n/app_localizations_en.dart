// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'InspireMe';

  @override
  String get splashSubtitle => 'Your daily dose of inspiration';

  @override
  String get loading => 'Loading...';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get inspireAgain => 'Inspire Me Again ✦';

  @override
  String get quoteLoadError => 'The message could not be loaded.';
}
