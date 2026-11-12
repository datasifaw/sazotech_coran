import 'dart:convert';
import 'package:flutter/services.dart';

/// Le script de preparation telecharge les versets d'une source reconnue
/// et les laisse inchanges dans assets/quran/coran_114.json.
class Sourate114 {
  const Sourate114({
    required this.numero,
    required this.nom,
    required this.nomArabe,
    required this.versets,
  });

  final int numero;
  final String nom;
  final String nomArabe;
  final List<String> versets;
}

class Corpus114 {
  const Corpus114({required this.source, required this.url, required this.sourates});
  final String source;
  final String url;
  final List<Sourate114> sourates;

  Sourate114? trouver(int numero) {
    if (numero < 1 || numero > sourates.length) return null;
    return sourates[numero - 1];
  }
}

class Coran114Store {
  static Future<Corpus114?>? _future;
  static Future<Corpus114?> charger() => _future ??= _charger();

  static Future<Corpus114?> _charger() async {
    try {
      final raw = await rootBundle.loadString('assets/quran/coran_114.json');
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      final rows = parsed['sourates'] as List<dynamic>;
      final sourates = rows.map((row) {
        final item = row as Map<String, dynamic>;
        return Sourate114(
          numero: (item['numero'] as num).toInt(),
          nom: item['nom'].toString(),
          nomArabe: item['nomArabe'].toString(),
          versets: List<String>.from(item['versets'] as List<dynamic>),
        );
      }).toList(growable: false);
      final total = sourates.fold<int>(0, (sum, s) => sum + s.versets.length);
      if (sourates.length != 114 || total != 6236) {
        throw const FormatException('Corpus coranique incomplet.');
      }
      for (var i = 0; i < sourates.length; i++) {
        final s = sourates[i];
        if (s.numero != i + 1 || s.nom.trim().isEmpty ||
            s.nomArabe.trim().isEmpty || s.versets.isEmpty ||
            s.versets.any((v) => v.trim().isEmpty)) {
          throw const FormatException('Numero ou texte de sourate invalide.');
        }
      }
      return Corpus114(
        source: parsed['source'].toString(),
        url: parsed['source_url'].toString(),
        sourates: sourates,
      );
    } catch (e) {
      // Le lecteur historique 4 sourates reste fonctionnel si le corpus manque.
      return null;
    }
  }
}
