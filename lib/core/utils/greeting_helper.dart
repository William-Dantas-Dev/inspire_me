import '../../l10n/app_localizations.dart';

String getGreeting(AppLocalizations l10n) {
  final hour = DateTime.now().hour;

  if (hour < 12) return l10n.goodMorning;
  if (hour < 18) return l10n.goodAfternoon;
  return l10n.goodEvening;
}