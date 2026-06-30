import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper tipado sobre shared_preferences.
/// Centraliza la persistencia local para guardar JSON y valores simples.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  /// Crea el servicio resolviendo la instancia de SharedPreferences.
  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<void> remove(String key) => _prefs.remove(key);

  bool containsKey(String key) => _prefs.containsKey(key);
}
