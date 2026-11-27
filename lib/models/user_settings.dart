import 'dart:typed_data';

class UserSettings {
  const UserSettings({
    this.displayName = '',
    this.age = '',
    this.heightCm = '',
    this.weightKg = '',
    this.goal = 'Remise en forme',
    this.targetWeightKg = '',
    this.level = 'Débutant',
    this.sessionsPerWeek = '',
    this.sessionDurationMinutes = '',
    this.healthNotes = '',
    this.profileImageBytes,
    this.restSeconds = 90,
    this.weightUnit = 'kg',
    this.isDarkMode = false,
  });

  final String displayName;
  final String age;
  final String heightCm;
  final String weightKg;
  final String goal;
  final String targetWeightKg;
  final String level;
  final String sessionsPerWeek;
  final String sessionDurationMinutes;
  final String healthNotes;
  final Uint8List? profileImageBytes;
  final int restSeconds;
  final String weightUnit;
  final bool isDarkMode;

  /// Reconstruit les préférences locales à partir des valeurs lues dans Hive.
  factory UserSettings.fromMap(Map<dynamic, dynamic>? values) {
    final settings = values ?? const <dynamic, dynamic>{};
    return UserSettings(
      displayName: settings['displayName'] as String? ?? '',
      age: settings['age'] as String? ?? '',
      heightCm: settings['heightCm'] as String? ?? '',
      weightKg: settings['weightKg'] as String? ?? '',
      goal: settings['goal'] as String? ?? 'Remise en forme',
      targetWeightKg: settings['targetWeightKg'] as String? ?? '',
      level: settings['level'] as String? ?? 'Débutant',
      sessionsPerWeek: settings['sessionsPerWeek'] as String? ?? '',
      sessionDurationMinutes: settings['sessionDurationMinutes'] as String? ?? '',
      healthNotes: settings['healthNotes'] as String? ?? '',
      profileImageBytes: settings['profileImageBytes'] as Uint8List?,
      restSeconds: settings['restSeconds'] as int? ?? 90,
      weightUnit: settings['weightUnit'] as String? ?? 'kg',
      isDarkMode: settings['isDarkMode'] as bool? ?? false,
    );
  }

  /// Transforme les préférences en valeurs compatibles avec le stockage Hive.
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'targetWeightKg': targetWeightKg,
      'level': level,
      'sessionsPerWeek': sessionsPerWeek,
      'sessionDurationMinutes': sessionDurationMinutes,
      'healthNotes': healthNotes,
      'profileImageBytes': profileImageBytes,
      'restSeconds': restSeconds,
      'weightUnit': weightUnit,
      'isDarkMode': isDarkMode,
    };
  }
}
