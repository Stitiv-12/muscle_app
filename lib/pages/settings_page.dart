import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muscle_app/models/user_settings.dart';
import 'package:muscle_app/providers/settings_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _sessionsController = TextEditingController();
  final _durationController = TextEditingController();
  final _restController = TextEditingController();
  final _healthNotesController = TextEditingController();
  late String _goal;
  late String _level;
  late String _weightUnit;
  late bool _isDarkMode;
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _displayNameController.text = settings.displayName;
    _ageController.text = settings.age;
    _heightController.text = settings.heightCm;
    _weightController.text = settings.weightKg;
    _targetWeightController.text = settings.targetWeightKg;
    _sessionsController.text = settings.sessionsPerWeek;
    _durationController.text = settings.sessionDurationMinutes;
    _restController.text = settings.restSeconds.toString();
    _healthNotesController.text = settings.healthNotes;
    _goal = settings.goal;
    _level = settings.level;
    _weightUnit = settings.weightUnit;
    _isDarkMode = settings.isDarkMode;
    _profileImageBytes = settings.profileImageBytes;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _sessionsController.dispose();
    _durationController.dispose();
    _restController.dispose();
    _healthNotesController.dispose();
    super.dispose();
  }

  /// Ouvre la galerie et conserve l'image dans le stockage local de l'application.
  Future<void> _pickProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;

    final imageBytes = await image.readAsBytes();
    if (mounted) setState(() => _profileImageBytes = imageBytes);
  }

  /// Valide puis enregistre le profil et les préférences de l'utilisateur.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(settingsProvider.notifier).save(
          UserSettings(
            displayName: _displayNameController.text.trim(),
            age: _ageController.text.trim(),
            heightCm: _heightController.text.trim(),
            weightKg: _weightController.text.trim(),
            goal: _goal,
            targetWeightKg: _targetWeightController.text.trim(),
            level: _level,
            sessionsPerWeek: _sessionsController.text.trim(),
            sessionDurationMinutes: _durationController.text.trim(),
            healthNotes: _healthNotesController.text.trim(),
            profileImageBytes: _profileImageBytes,
            restSeconds: int.parse(_restController.text),
            weightUnit: _weightUnit,
            isDarkMode: _isDarkMode,
          ),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil et préférences enregistrés.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _profileImageBytes != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundImage: hasImage
                        ? MemoryImage(_profileImageBytes!)
                        : null,
                    child: hasImage ? null : const Icon(Icons.person, size: 58),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton.filled(
                      tooltip: 'Choisir une photo de profil',
                      onPressed: _pickProfileImage,
                      icon: const Icon(Icons.photo_library),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, 'Profil'),
            _textField(_displayNameController, 'Prénom ou pseudo'),
            _numberField(_ageController, 'Âge', maxDigits: 3),
            _numberField(_heightController, 'Taille (cm)', maxDigits: 3),
            _decimalField(
              _weightController,
              'Poids actuel ($_weightUnit)',
              maxWholeDigits: 3,
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'Objectif'),
            DropdownButtonFormField<String>(
              value: _goal,
              decoration: const InputDecoration(labelText: 'Objectif principal'),
              items: const [
                'Prise de muscle',
                'Perte de poids',
                'Force',
                'Remise en forme',
              ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => _goal = value!),
            ),
            _decimalField(
              _targetWeightController,
              'Poids cible ($_weightUnit)',
              maxWholeDigits: 3,
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'Habitudes d’entraînement'),
            DropdownButtonFormField<String>(
              value: _level,
              decoration: const InputDecoration(labelText: 'Niveau'),
              items: const ['Débutant', 'Intermédiaire', 'Avancé']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) => setState(() => _level = value!),
            ),
            _numberField(_sessionsController, 'Séances par semaine'),
            _numberField(_durationController, 'Durée habituelle (minutes)'),
            const SizedBox(height: 16),
            _sectionTitle(context, 'Préférences'),
            _numberField(
              _restController,
              'Temps de repos par défaut (secondes)',
              required: true,
              allowZero: true,
            ),
            DropdownButtonFormField<String>(
              value: _weightUnit,
              decoration: const InputDecoration(labelText: 'Unité de poids'),
              items: const [
                DropdownMenuItem(value: 'kg', child: Text('Kilogrammes (kg)')),
                DropdownMenuItem(value: 'lb', child: Text('Livres (lb)')),
              ],
              onChanged: (value) => setState(() => _weightUnit = value!),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Thème sombre'),
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value),
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'Santé et limites'),
            TextFormField(
              controller: _healthNotesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Blessures, zones à éviter ou notes personnelles',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  /// Crée un titre de section homogène dans la page de paramètres.
  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  /// Construit un champ texte optionnel du profil.
  Widget _textField(TextEditingController controller, String label) {
    return TextFormField(controller: controller, decoration: InputDecoration(labelText: label));
  }

  /// Construit un champ entier facultatif ou obligatoire avec validation.
  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool required = false,
    bool allowZero = false,
    int? maxDigits,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (maxDigits != null) LengthLimitingTextInputFormatter(maxDigits),
      ],
      validator: (value) {
        if ((value ?? '').isEmpty && !required) return null;
        final number = int.tryParse(value ?? '');
        if (number == null || (allowZero ? number < 0 : number <= 0)) {
          return 'Indique un nombre ${allowZero ? 'positif ou nul' : 'supérieur à 0'}.';
        }
        return null;
      },
    );
  }

  /// Construit un champ de poids acceptant uniquement un nombre décimal positif.
  Widget _decimalField(
    TextEditingController controller,
    String label, {
    int maxWholeDigits = 3,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp('^\\d{0,$maxWholeDigits}([,.]\\d{0,2})?\$'),
        ),
      ],
      validator: (value) {
        if ((value ?? '').isEmpty) return null;
        final number = double.tryParse(value!.replaceAll(',', '.'));
        if (number == null || number <= 0) {
          return 'Indique un poids supérieur à 0.';
        }
        return null;
      },
    );
  }
}
