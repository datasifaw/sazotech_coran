import 'package:flutter/material.dart';
import 'coran_114_store.dart';
import 'memorisation_store.dart';

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);

class SuiviMemorisationScreen extends StatefulWidget {
  const SuiviMemorisationScreen({super.key, required this.onOuvrir});
  final Future<void> Function(int) onOuvrir;

  @override
  State<SuiviMemorisationScreen> createState() => _SuiviMemorisationScreenState();
}

class _SuiviMemorisationScreenState extends State<SuiviMemorisationScreen> {
  Corpus114? _corpus;
  Set<int> _apprises = {};
  bool _charge = false;
  bool _uniquementAReviser = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final results = await Future.wait<Object?>([
        Coran114Store.charger(),
        MemorisationStore.lire(),
      ]);
      if (!mounted) return;
      setState(() {
        _corpus = results[0] as Corpus114?;
        _apprises = results[1] as Set<int>;
        _charge = true;
      });
    } catch (_) {
      if (mounted) setState(() => _charge = true);
    }
  }

  Future<void> _changer(int numero) async {
    try {
      final valeurs = await MemorisationStore.basculer(numero);
      if (mounted) setState(() => _apprises = valeurs);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sauvegarde locale indisponible.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourates = _corpus?.sourates ?? <Sourate114>[];
    final affichees = sourates.where((s) =>
      !_uniquementAReviser || !_apprises.contains(s.numero)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Mon suivi de mémorisation'),
          backgroundColor: _navy, foregroundColor: Colors.white),
      body: !_charge
        ? const Center(child: CircularProgressIndicator())
        : sourates.isEmpty
          ? const Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Le texte des 114 sourates n’est pas installé. '
                  'Exécute installer_etapes_10_11_12.ps1 sur ton PC.',
                  textAlign: TextAlign.center)))
          : Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(16, 18, 16, 8), child:
                Card(color: const Color(0xFF113454), child:
                  Padding(padding: const EdgeInsets.all(20), child:
                    Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Text('Sourates mémorisées', style: TextStyle(color: _cyan)),
                      const SizedBox(height: 8),
                      Text('${_apprises.length} / 114', style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _apprises.length / 114,
                        color: _cyan, backgroundColor: const Color(0xFF245375), minHeight: 9,
                      ),
                      const SizedBox(height: 8),
                      Text('${(_apprises.length / 114 * 100).toStringAsFixed(1)} % du Coran',
                        style: const TextStyle(color: Colors.white70)),
                    ]),
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                value: _uniquementAReviser,
                title: const Text('Afficher seulement les sourates à apprendre'),
                onChanged: (v) => setState(() => _uniquementAReviser = v),
                activeThumbColor: _cyan,
              ),
              Expanded(child: ListView.builder(
                itemCount: affichees.length,
                itemBuilder: (context, index) {
                  final s = affichees[index];
                  final ok = _apprises.contains(s.numero);
                  return ListTile(
                    key: Key('progression_sourate_${s.numero}'),
                    leading: CircleAvatar(backgroundColor: const Color(0xFF113454),
                      child: Text('${s.numero}',style: const TextStyle(color: _cyan))),
                    title: Text(s.nom),
                    subtitle: Text('${s.versets.length} versets • ${ok ? "Mémorisée" : "À apprendre"}'),
                    trailing: IconButton(
                      tooltip: ok ? 'Marquer à réviser' : 'Marquer comme mémorisée',
                      icon: Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: _cyan),
                      onPressed: () => _changer(s.numero),
                    ),
                    onTap: () async { await widget.onOuvrir(s.numero); await _charger(); },
                  );
                },
              )),
            ]),
    );
  }
}
