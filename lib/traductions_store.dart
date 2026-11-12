import 'dart:convert';
import 'package:flutter/services.dart';

/// Texte original, sans retouche, renvoye par l'API QuranEnc (Rachid Maach).
/// Le fichier JSON est prepare localement par installer_etapes_7_8_9.ps1.
class TraductionVerset {
  const TraductionVerset(this.texte, this.notes);
  final String texte;
  final String notes;
}

class PackTraductions {
  const PackTraductions({
    required this.titre,
    required this.version,
    required this.sourates,
  });
  final String titre;
  final String version;
  final Map<int, List<TraductionVerset>> sourates;

  List<TraductionVerset> pour(int numero) =>
      sourates[numero] ?? <TraductionVerset>[];
}

class TraductionsStore {
  static const source = 'https://quranenc.com/fr/browse/french_rashid';
  static Future<PackTraductions?>? _memo;

  static Future<PackTraductions?> charger() =>
      _memo ??= _chargerDepuisAssets();

  static Future<PackTraductions?> _chargerDepuisAssets() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/traductions/quranenc_french_rashid.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['edition_key'] != 'french_rashid') return null;
      final obj = json['sourates'] as Map<String, dynamic>;
      final sourates = <int, List<TraductionVerset>>{};
      for (final entry in obj.entries) {
        final numero = int.tryParse(entry.key);
        if (numero == null) continue;
        final values = entry.value as List<dynamic>;
        sourates[numero] = values.map((item) {
          final v = item as Map<String, dynamic>;
          return TraductionVerset(
            (v['translation'] ?? '').toString(),
            (v['footnotes'] ?? '').toString(),
          );
        }).toList();
      }
      return PackTraductions(
        titre: (json['title'] ?? 'Rachid Maach').toString(),
        version: (json['version'] ?? 'non indiquee').toString(),
        sourates: sourates,
      );
    } catch (_) {
      // Le prototype peut se lancer meme si le telechargement n'a pas reussi.
      return null;
    }
  }
}
