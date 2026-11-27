import 'package:flutter_test/flutter_test.dart';
import 'package:muscle_app/models/user_settings.dart';

void main() {
  test('uses defaults when no preference was previously saved', () {
    final settings = UserSettings.fromMap(null);

    expect(settings.restSeconds, 90);
    expect(settings.weightUnit, 'kg');
    expect(settings.isDarkMode, isFalse);
  });

  test('keeps the profile preferences after serialization', () {
    const original = UserSettings(
      displayName: 'Alex',
      goal: 'Force',
      restSeconds: 120,
      weightUnit: 'lb',
      isDarkMode: true,
      profileImageBytes: Uint8List.fromList([1, 2, 3]),
    );

    final restored = UserSettings.fromMap(original.toMap());

    expect(restored.displayName, 'Alex');
    expect(restored.goal, 'Force');
    expect(restored.restSeconds, 120);
    expect(restored.weightUnit, 'lb');
    expect(restored.isDarkMode, isTrue);
    expect(restored.profileImageBytes, Uint8List.fromList([1, 2, 3]));
  });
}
import 'dart:typed_data';

