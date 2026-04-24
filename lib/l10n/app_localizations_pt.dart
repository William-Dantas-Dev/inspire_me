// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'InspireMe';

  @override
  String get splashSubtitle => 'Sua dose diária de inspiração';

  @override
  String get loading => 'Carregando...';

  @override
  String get goodMorning => 'Bom dia';

  @override
  String get goodAfternoon => 'Boa tarde';

  @override
  String get goodEvening => 'Boa noite';

  @override
  String get inspireAgain => 'Me Inspire Novamente ✦';

  @override
  String get quoteLoadError => 'Não foi possível carregar a mensagem.';
}
