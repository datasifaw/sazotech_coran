import 'package:shared_preferences/shared_preferences.dart';

/// Memorisation persistante des sourates apprises; ne supprime pas les favoris.
class MemorisationStore {
  static const cle = 'sazotech_coran_sourates_apprises_v1';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<Set<int>> lire() async {
    final items = await _prefs.getStringList(cle) ?? <String>[];
    return items.map(int.tryParse)
        .whereType<int>()
        .where((numero) => numero >= 1 && numero <= 114)
        .toSet();
  }

  static Future<Set<int>> basculer(int numero) async {
    if (numero < 1 || numero > 114) throw RangeError.range(numero, 1, 114);
    final learned = await lire();
    if (!learned.add(numero)) learned.remove(numero);
    await _prefs.setStringList(cle, learned.map((n) => '$n').toList()..sort((a,b) => int.parse(a).compareTo(int.parse(b))));
    return learned;
  }
}

class DernierVerset114 {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static String cle(int sourate) => 'sazotech_coran_reprise_114_$sourate';
  static Future<int?> lire(int sourate) => _prefs.getInt(cle(sourate));
  static Future<void> enregistrer(int sourate, int verset) =>
      _prefs.setInt(cle(sourate), verset);
}
