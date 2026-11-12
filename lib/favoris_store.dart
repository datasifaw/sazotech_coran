import 'package:shared_preferences/shared_preferences.dart';

/// Stockage local des favoris. Identifiant stable : « numeroSourate:numeroVerset ».
/// N'efface jamais l'ancien marque-page d'Al-Fatiha ni le meilleur score du quiz.
class FavorisStore {
  static const cle = 'sazotech_coran_favoris_v1';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static String id(int sourate, int verset) => '$sourate:$verset';

  static Future<Set<String>> lire() async {
    return (await _prefs.getStringList(cle) ?? <String>[]).toSet();
  }

  static Future<Set<String>> basculer(int sourate, int verset) async {
    final favoris = await lire();
    final identifiant = id(sourate, verset);
    if (!favoris.add(identifiant)) {
      favoris.remove(identifiant);
    }
    await _prefs.setStringList(cle, favoris.toList()..sort());
    return favoris;
  }

  static Future<Set<String>> supprimer(int sourate, int verset) async {
    final favoris = await lire();
    favoris.remove(id(sourate, verset));
    await _prefs.setStringList(cle, favoris.toList()..sort());
    return favoris;
  }
}
