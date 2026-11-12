import 'package:flutter/material.dart';
import 'coran_114_store.dart';
import 'memorisation_store.dart';
import 'favoris_store.dart';
import 'traductions_store.dart';
import 'audio_sourate_widget.dart';

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);
const _card = Color(0xFF113454);
const _border = Color(0xFF19608B);

String _normaliser(String chaine) => chaine.toLowerCase()
    .replaceAll('à', 'a').replaceAll('â', 'a').replaceAll('ä', 'a')
    .replaceAll('é', 'e').replaceAll('è', 'e').replaceAll('ê', 'e')
    .replaceAll('ë', 'e').replaceAll('î', 'i').replaceAll('ï', 'i')
    .replaceAll('ô', 'o').replaceAll('ö', 'o').replaceAll('û', 'u')
    .replaceAll('ù', 'u').replaceAll('ü', 'u').replaceAll('ç', 'c');

class Bibliotheque114Screen extends StatefulWidget {
  const Bibliotheque114Screen({super.key, required this.onOuvrir});
  final Future<void> Function(int, {int? verset}) onOuvrir;

  @override
  State<Bibliotheque114Screen> createState() => _Bibliotheque114ScreenState();
}

class _Bibliotheque114ScreenState extends State<Bibliotheque114Screen> {
  Corpus114? _corpus;
  bool _charge = false;
  String _filtre = '';
  Set<int> _apprises = {};

  @override
  void initState() { super.initState(); _charger(); }

  Future<void> _charger() async {
    try {
      final corpus = await Coran114Store.charger();
      final apprises = await MemorisationStore.lire();
      if (!mounted) return;
      setState(() { _corpus = corpus; _apprises = apprises; _charge = true; });
    } catch (_) {
      if (mounted) setState(() => _charge = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourates = _corpus?.sourates ?? <Sourate114>[];
    final filtre = _normaliser(_filtre.trim());
    final resultat = sourates.where((s) =>
      _normaliser(s.nom).contains(filtre) || s.nomArabe.contains(filtre) ||
      s.numero.toString() == filtre).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Les 114 sourates'),
          backgroundColor: _navy, foregroundColor: Colors.white),
      body: !_charge ? const Center(child: CircularProgressIndicator())
        : sourates.isEmpty ? Center(child: Padding(
            padding: const EdgeInsets.all(24), child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.menu_book, color: _cyan, size: 48),
              const SizedBox(height: 15),
              const Text('Le corpus des 114 sourates n’est pas encore disponible. '
                'Lance installer_etapes_10_11_12.ps1 dans le dossier du projet. ',
                textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Tes quatre sourates précédentes restent accessibles depuis l’accueil.',
                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white70))],
            ))) : Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: TextField(
                  key: const Key('recherche_sourate'),
                  onChanged: (s) => setState(() => _filtre = s),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou numéro…',
                    prefixIcon: const Icon(Icons.search, color: _cyan),
                    filled: true, fillColor: _card,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
                child: Align(alignment: Alignment.centerLeft,
                  child: Text('${resultat.length} sourate(s) • lecture hors ligne',
                    style: const TextStyle(color: Colors.white70))),
              ),
              Expanded(child: ListView.builder(
                itemCount: resultat.length,
                itemBuilder: (context, index) {
                  final s = resultat[index];
                  return Card(
                    color: _card, margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    child: ListTile(
                      key: Key('sourate_${s.numero}'),
                      onTap: () async { await widget.onOuvrir(s.numero); await _charger(); },
                      leading: CircleAvatar(backgroundColor: const Color(0xFF07325D),
                        child: Text('${s.numero}',style: const TextStyle(color: _cyan))),
                      title: Text(s.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${s.versets.length} versets${s.numero == 1 || s.numero >= 112 ? " • audio local" : ""}'),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        if (_apprises.contains(s.numero))
                          const Icon(Icons.check_circle, color: _cyan, size: 20),
                        const SizedBox(width: 5),
                        SizedBox(width: 85, child: Text(s.nomArabe,
                          textDirection: TextDirection.rtl, maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17, color: _cyan))),
                        const Icon(Icons.chevron_right, color: Colors.white70),
                      ]),
                    ),
                  );
                },
              )),
              Padding(padding: const EdgeInsets.all(9),
                child: Text('Texte arabe : ${_corpus!.source} • ${_corpus!.url}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.white70))),
            ]),
    );
  }
}

class Lecture114Screen extends StatefulWidget {
  const Lecture114Screen({super.key, required this.sourate, this.initialVerse});
  final Sourate114 sourate;
  final int? initialVerse;

  @override
  State<Lecture114Screen> createState() => _Lecture114ScreenState();
}

class _Lecture114ScreenState extends State<Lecture114Screen> {
  Set<String> _favoris = {};
  bool _memorisee = false;
  bool _traductionVisible = true;
  PackTraductions? _pack;
  int? _dernierVerset;
  late final List<GlobalKey> _ancres;

  @override
  void initState() {
    super.initState();
    _ancres = List.generate(widget.sourate.versets.length, (_) => GlobalKey());
    _charger();
  }

  Future<void> _charger() async {
    try {
      final favoris = await FavorisStore.lire();
      final apprises = await MemorisationStore.lire();
      final pack = await TraductionsStore.charger();
      final dernier = widget.initialVerse ?? await DernierVerset114.lire(widget.sourate.numero);
      if (!mounted) return;
      setState(() {
        _favoris = favoris;
        _memorisee = apprises.contains(widget.sourate.numero);
        _pack = pack;
        _dernierVerset = dernier;
      });
      if (dernier != null && dernier >= 1 && dernier <= _ancres.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final c = _ancres[dernier - 1].currentContext;
          if (c != null) Scrollable.ensureVisible(c, duration: const Duration(milliseconds: 350), alignment: .10);
        });
      }
    } catch (error) {
      debugPrint('SAZOTECH: lecture memorisation $error');
    }
  }

  Future<void> _basculerMemorisation() async {
    try {
      final apprises = await MemorisationStore.basculer(widget.sourate.numero);
      if (mounted) setState(() => _memorisee = apprises.contains(widget.sourate.numero));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’enregistrer cette sourate.')));
    }
  }

  Future<void> _favori(int verset) async {
    try {
      final result = await FavorisStore.basculer(widget.sourate.numero, verset);
      if (mounted) setState(() => _favoris = result);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favori non enregistré.')));
    }
  }

  Future<void> _enregistrerVerset(int verset) async {
    try {
      await DernierVerset114.enregistrer(widget.sourate.numero, verset);
      if (mounted) setState(() => _dernierVerset = verset);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sauvegarde du verset impossible.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sourate;
    final trad = _pack?.pour(s.numero) ?? <TraductionVerset>[];
    return Scaffold(
      appBar: AppBar(title: Text(s.nom), backgroundColor: _navy,
        foregroundColor: Colors.white),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
        children: [
          Text(s.nomArabe, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 32, color: _cyan, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Sourate ${s.numero} • ${s.versets.length} versets',
            textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _basculerMemorisation,
            style: FilledButton.styleFrom(backgroundColor: _cyan, foregroundColor: _navy),
            icon: Icon(_memorisee ? Icons.check_circle : Icons.check_circle_outline),
            label: Text(_memorisee ? 'Sourate mémorisée ✓' : 'Marquer comme mémorisée'),
          ),
          const SizedBox(height: 12),
          if (const [1, 112, 113, 114].contains(s.numero)) ...[
            AudioSourateWidget(numero: s.numero, nom: s.nom),
            const SizedBox(height: 14),
          ],
          if (trad.isNotEmpty) SwitchListTile.adaptive(
            title: const Text('Traduction française'),
            subtitle: const Text('Rachid Maach • QuranEnc'),
            value: _traductionVisible,
            onChanged: (v) => setState(() => _traductionVisible = v),
            activeThumbColor: _cyan,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < s.versets.length; i++) ...[
            InkWell(
              key: _ancres[i],
              onTap: () => _enregistrerVerset(i + 1),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _dernierVerset == i + 1 ? _cyan : _border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Text('Verset ${i + 1}${_dernierVerset == i + 1 ? " • Dernier lu" : ""}',
                      style: const TextStyle(color: _cyan)),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Ajouter ou retirer des favoris',
                      icon: Icon(_favoris.contains(FavorisStore.id(s.numero, i + 1))
                        ? Icons.star_rounded : Icons.star_outline_rounded, color: _cyan),
                      onPressed: () => _favori(i + 1),
                    ),
                  ]),
                  Text(s.versets[i], textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 27, height: 1.9, color: Colors.white)),
                  if (_traductionVisible && i < trad.length) ...[
                    const Divider(height: 22),
                    Text(trad[i].texte, style: const TextStyle(color: Color(0xFFE9F5FF), height: 1.5)),
                  ],
                ]),
              ),
            ),
            const SizedBox(height: 12),
          ],
          const Text('Les traductions françaises restent celles du paquet installé. '
            'Les textes arabes des 114 sourates sont consultables hors ligne.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      )),
    );
  }
}
