import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'InspireMe'**
  String get appName;

  /// Splash screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your daily dose of inspiration'**
  String get splashSubtitle;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Greeting shown in the morning
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Greeting shown in the afternoon
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// Greeting shown in the evening
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// Button label to refresh the inspirational quote
  ///
  /// In en, this message translates to:
  /// **'Inspire Me Again ✦'**
  String get inspireAgain;

  /// Error message when loading a phrase.
  ///
  /// In en, this message translates to:
  /// **'The message could not be loaded.'**
  String get quoteLoadError;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Preferences section
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Notification setting title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettingTitle;

  /// Notification setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive inspirational quotes during the day'**
  String get notificationSettingSubtitle;

  /// Notification start time title
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get notificationStartTime;

  /// Notification end time title
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get notificationEndTime;

  /// Notification vibration setting title
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get notificationVibration;

  /// Notification vibration setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Vibrate when a notification is shown'**
  String get notificationVibrationSubtitle;

  /// Message shown when removing a quote from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// Text shown when an item is waiting to be removed from favorites
  ///
  /// In en, this message translates to:
  /// **'Pending removal...'**
  String get favoritePendingRemoval;

  /// Tooltip for share button
  ///
  /// In en, this message translates to:
  /// **'Share quote'**
  String get favoriteShareTooltip;

  /// Tooltip for remove favorite button
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteRemoveTooltip;

  /// Tooltip when item is pending removal and can be undone
  ///
  /// In en, this message translates to:
  /// **'Waiting for undo'**
  String get favoritePendingTooltip;

  /// Title when there are no favorite quotes
  ///
  /// In en, this message translates to:
  /// **'No favorite quotes yet.'**
  String get favoriteEmptyTitle;

  /// Subtitle when there are no favorite quotes
  ///
  /// In en, this message translates to:
  /// **'Favorite a quote on the main screen to see it here.'**
  String get favoriteEmptySubtitle;

  /// Error message when loading favorites
  ///
  /// In en, this message translates to:
  /// **'Could not load favorites.'**
  String get favoriteErrorTitle;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Text shown while sharing is in progress
  ///
  /// In en, this message translates to:
  /// **'Sharing...'**
  String get sharing;

  /// Error message when sharing an image
  ///
  /// In en, this message translates to:
  /// **'The image could not be shared.'**
  String get shareImageError;

  /// Action to undo a removal
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// Terms of use title
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// Privacy policy title
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
