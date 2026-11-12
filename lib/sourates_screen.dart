import 'package:flutter/material.dart';
import 'audio_sourate_widget.dart';
import 'favoris_store.dart';
import 'traductions_store.dart';

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
            const Text('4 sourates à lire et écouter',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 21,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Texte arabe • Audio local • Favoris • Traduction française',
              textAlign: TextAlign.center,
              style: TextStyle(color: _softWhite),
            ),
            const SizedBox(height: 22),
            _carteSourate(context, 1, 'Al-Fatiha', 'الْفَاتِحَة', 7,
                onOuvrirFatiha),
            for (final sourate in petitesSourates) ...[
              const SizedBox(height: 12),
              _carteSourate(context, sourate.numero, sourate.nomFrancais,
                  sourate.nomArabe, sourate.versets.length, () async {
                await Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => LectureSourateCourteScreen(sourate: sourate),
                ));
              }),
            ],
            const SizedBox(height: 22),
            const Text(
              'Traduction des sens : Rachid Maach / QuranEnc.com. '
              'Récitation : Mishary Al-Afasy / Al Quran Cloud.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _softWhite, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carteSourate(BuildContext context, int numero, String nomFrancais,
      String nomArabe, int nombreVersets, Future<void> Function() onTap) {
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
          child: Row(children: [
            Container(
              width: 43,
              height: 43,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF07325D),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text('$numero',
                style: const TextStyle(color: _cyan, fontSize: 17,
                    fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 13),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nomFrancais, style: const TextStyle(color: Colors.white,
                    fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text('$nombreVersets versets • audio & favoris',
                    style: const TextStyle(color: _softWhite, fontSize: 12)),
              ],
            )),
            Text(nomArabe, textDirection: TextDirection.rtl,
                style: const TextStyle(color: _cyan, fontSize: 21)),
            const SizedBox(width: 7),
            const Icon(Icons.chevron_right_rounded, color: _softWhite),
          ]),
        ),
      ),
    );
  }
}

class LectureSourateCourteScreen extends StatefulWidget {
  const LectureSourateCourteScreen({
    super.key,
    required this.sourate,
    this.initialVerse,
  });

  final SourateCourte sourate;
  final int? initialVerse;

  @override
  State<LectureSourateCourteScreen> createState() =>
      _LectureSourateCourteScreenState();
}

class _LectureSourateCourteScreenState extends State<LectureSourateCourteScreen> {
  Set<String> _favoris = {};
  PackTraductions? _pack;
  bool _traductionVisible = true;
  final Map<int, GlobalKey> _ancres = {};

  @override
  void initState() {
    super.initState();
    for (var v = 1; v <= widget.sourate.versets.length; v++) {
      _ancres[v] = GlobalKey();
    }
    _chargerDonnees();
    WidgetsBinding.instance.addPostFrameCallback((_) => _voirVerset());
  }

  void _voirVerset() {
    final verse = widget.initialVerse;
    if (verse == null || !mounted) return;
    final ctx = _ancres[verse]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 400), alignment: .1);
  }

  Future<void> _chargerDonnees() async {
    try {
      final favoris = await FavorisStore.lire();
      final pack = await TraductionsStore.charger();
      if (mounted) setState(() { _favoris = favoris; _pack = pack; });
    } catch (error) {
      debugPrint('SAZOTECH favoris/traductions : $error');
    }
  }

  Future<void> _basculerFavori(int verse) async {
    try {
      final favoris = await FavorisStore.basculer(widget.sourate.numero, verse);
      if (mounted) setState(() => _favoris = favoris);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’enregistrer ce favori.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourate = widget.sourate;
    final traductions = _pack?.pour(sourate.numero) ?? <TraductionVerset>[];
    return Scaffold(
      appBar: AppBar(backgroundColor: _navy, foregroundColor: Colors.white,
        title: Text(sourate.nomFrancais)),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          Text(sourate.nomArabe, textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _cyan, fontSize: 30,
              fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text('Sourate ${sourate.numero} • ${sourate.versets.length} versets',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _softWhite)),
          const SizedBox(height: 18),
          AudioSourateWidget(numero: sourate.numero, nom: sourate.nomFrancais),
          const SizedBox(height: 14),
          SwitchListTile.adaptive(
            key: const Key('traduction_switch_courte'),
            value: _traductionVisible,
            onChanged: (value) => setState(() => _traductionVisible = value),
            title: const Text('Traduction française'),
            subtitle: const Text('Sens des versets • Rachid Maach / QuranEnc'),
            activeThumbColor: _cyan,
            secondary: const Icon(Icons.translate, color: _cyan),
          ),
          if (_traductionVisible && traductions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('Traduction non disponible : exécute le script '
                  'installer_etapes_7_8_9.ps1 sur ton PC.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orangeAccent)),
            ),
          const SizedBox(height: 12),
          const Text(basmalaSouratesCourtes,
              textDirection: TextDirection.rtl, textAlign: TextAlign.center,
              style: TextStyle(color: _cyan, fontSize: 25, height: 1.8)),
          const SizedBox(height: 18),
          for (var index = 0; index < sourate.versets.length; index++) ...[
            Container(
              key: _ancres[index + 1],
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: _card,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(18)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    Text('Verset ${index + 1}',
                        style: const TextStyle(color: _cyan, fontSize: 13)),
                    const Spacer(),
                    IconButton(
                      key: Key('favori_${sourate.numero}_${index + 1}'),
                      tooltip: 'Ajouter/retirer des favoris',
                      onPressed: () => _basculerFavori(index + 1),
                      icon: Icon(_favoris.contains(FavorisStore.id(sourate.numero, index + 1))
                          ? Icons.star_rounded : Icons.star_border_rounded,
                          color: _cyan),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Text(sourate.versets[index],
                    textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white,
                        fontSize: 29, height: 1.9)),
                  if (_traductionVisible && index < traductions.length) ...[
                    const Divider(height: 28, color: _border),
                    Text(traductions[index].texte,
                        style: const TextStyle(color: _softWhite,
                          fontSize: 15, height: 1.5)),
                    if (traductions[index].notes.trim().isNotEmpty) ...[
                      const SizedBox(height: 9),
                      Text(traductions[index].notes,
                          style: const TextStyle(color: Color(0xFF9CBFD2),
                            fontSize: 12)),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 10),
          Text('Traduction du sens : Rachid Maach • QuranEnc.com • '
              'Version ${_pack?.version ?? "non chargée"}. '
              'Texte et notes conservés sans modification.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _softWhite, fontSize: 12)),
        ],
      )),
    );
  }
}
