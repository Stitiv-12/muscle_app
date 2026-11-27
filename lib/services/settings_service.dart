import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:muscle_app/models/user_settings.dart';

class SettingsService {
  static const _boxName = 'user_settings';
  static const _settingsKey = 'profile';

  Box<dynamic> get _box => Hive.box<dynamic>(_boxName);

  /// Retourne les préférences enregistrées ou les valeurs par défaut.
  UserSettings load() {
    final value = _box.get(_settingsKey);
    return UserSettings.fromMap(value is Map ? value : null);
  }

  /// Enregistre toutes les informations du profil sur l'appareil.
  Future<void> save(UserSettings settings) {
    return _box.put(_settingsKey, settings.toMap());
  }
}
