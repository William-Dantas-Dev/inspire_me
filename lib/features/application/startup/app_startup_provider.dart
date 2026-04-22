import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_startup_notifier.dart';
import 'app_startup_state.dart';

final appStartupProvider =
    NotifierProvider<AppStartupNotifier, AppStartupState>(
      AppStartupNotifier.new,
    );
