import 'package:flutter/material.dart';

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);
const _softWhite = Color(0xFFE9F5FF);
const _card = Color(0xFF113454);
const _border = Color(0xFF19608B);

/// Les sourates ci-dessous sont transcrites dans l'orthographe arabe
/// vérifiée sur https://quran.com/112, /113 et /114 (novembre 2026).
/// La basmala est affichée séparément et ne figure PAS dans les
/// décomptes de versets des sourates 112, 113 et 114.
/// Al-Fatiha reste dans le lecteur existant avec son audio et sa progression.
class SourateCourte {
  const SourateCourte({
    required this.numero,
    required this.nomFrancais,
    required this.nomArabe,
    required this.versets,
  });

  final int numero;
  final String nomFrancais;
  final String nomArabe;
  final List<String> versets;
}

const basmalaSouratesCourtes =
    'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';

const List<SourateCourte> petitesSourates = [
  SourateCourte(
    numero: 112,
    nomFrancais: 'Al-Ikhlas',
    nomArabe: 'الإِخْلَاص',
    versets: [
      'قُلْ هُوَ ٱللَّهُ أَحَدٌ',
      'ٱللَّهُ ٱلصَّمَدُ',
      'لَمْ يَلِدْ وَلَمْ يُولَدْ',
      'وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ',
    ],
  ),
  SourateCourte(
    numero: 113,
    nomFrancais: 'Al-Falaq',
    nomArabe: 'الْفَلَق',
    versets: [
      'قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ',
      'مِن شَرِّ مَا خَلَقَ',
      'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
      'وَمِن شَرِّ ٱلنَّفَّـٰثَـٰتِ فِى ٱلْعُقَدِ',
      'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
    ],
  ),
  SourateCourte(
    numero: 114,
    nomFrancais: 'An-Nas',
    nomArabe: 'النَّاس',
    versets: [
      'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
      'مَلِكِ ٱلنَّاسِ',
      'إِلَـٰهِ ٱلنَّاسِ',
      'مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ',
      'ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ',
      'مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ',
    ],
  ),
];

class BibliothequeSouratesScreen extends StatelessWidget {
  const BibliothequeSouratesScreen({
    super.key,
    required this.onOuvrirFatiha,
  });

  final Future<void> Function() onOuvrirFatiha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('Bibliothèque des sourates'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
          children: [
            const Icon(Icons.auto_stories_rounded, color: _cyan, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Commencer par les petites sourates',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '4 sourates disponibles pour la lecture hors ligne.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _softWhite),
            ),
            const SizedBox(height: 22),
            _carteSourate(
              context,
              numero: 1,
              nomFrancais: 'Al-Fatiha',
              nomArabe: 'الْفَاتِحَة',
              nombreVersets: 7,
              audioDisponible: true,
              onTap: onOuvrirFatiha,
            ),
            for (final sourate in petitesSourates) ...[
              const SizedBox(height: 12),
              _carteSourate(
                context,
                numero: sourate.numero,
                nomFrancais: sourate.nomFrancais,
                nomArabe: sourate.nomArabe,
                nombreVersets: sourate.versets.length,
                audioDisponible: false,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LectureSourateCourteScreen(sourate: sourate),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'La récitation audio, le quiz et le marque-page sont pour '
              'le moment disponibles uniquement pour Al-Fatiha.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _softWhite, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carteSourate(
    BuildContext context, {
    required int numero,
    required String nomFrancais,
    required String nomArabe,
    required int nombreVersets,
    required bool audioDisponible,
    required Future<void> Function() onTap,
  }) {
    return Material(
      color: _card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('sourate_$numero'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF07325D),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '$numero',
                  style: const TextStyle(
                    color: _cyan,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomFrancais,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$nombreVersets versets${audioDisponible ? ' • audio' : ' • texte'}',
                      style: const TextStyle(color: _softWhite, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                nomArabe,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: _cyan, fontSize: 21),
              ),
              const SizedBox(width: 7),
              const Icon(Icons.chevron_right_rounded, color: _softWhite),
            ],
          ),
        ),
      ),
    );
  }
}

class LectureSourateCourteScreen extends StatelessWidget {
  const LectureSourateCourteScreen({super.key, required this.sourate});

  final SourateCourte sourate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(sourate.nomFrancais),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
          children: [
            Text(
              sourate.nomArabe,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _cyan,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Sourate ${sourate.numero} • ${sourate.versets.length} versets',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _softWhite),
            ),
            const SizedBox(height: 22),
            const Text(
              basmalaSouratesCourtes,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(color: _cyan, fontSize: 26, height: 1.8),
            ),
            const SizedBox(height: 22),
            for (var index = 0; index < sourate.versets.length; index++) ...[
              Container(
                key: Key('sourate_${sourate.numero}_verset_${index + 1}'),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _card,
                  border: Border.all(color: _border),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Verset ${index + 1}',
                      style: const TextStyle(color: _cyan, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      sourate.versets[index],
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        height: 1.9,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            const Text(
              'Texte arabe disponible hors ligne. Audio à venir pour '
              'cette sourate. Vérification du texte : Quran.com.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _softWhite, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
