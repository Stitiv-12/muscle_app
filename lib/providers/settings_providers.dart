import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:muscle_app/models/user_settings.dart';
import 'package:muscle_app/services/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>(
  (ref) {
    return SettingsNotifier(ref.watch(settingsServiceProvider));
  },
);

class SettingsNotifier extends StateNotifier<UserSettings> {
  SettingsNotifier(this._service) : super(_service.load());

  final SettingsService _service;

  /// Sauvegarde les préférences puis actualise immédiatement l'interface.
  Future<void> save(UserSettings settings) async {
    await _service.save(settings);
    state = settings;
  }
}
