import 'package:flutter/material.dart';
import 'favoris_store.dart';
import 'coran_114_store.dart';

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key, required this.onOuvrir});
  final Future<void> Function(int sourate, int verset) onOuvrir;

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  Set<String> _favoris = {};
  Corpus114? _corpus;
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _actualiser();
  }

  Future<void> _actualiser() async {
    final favoris = await FavorisStore.lire();
    final corpus = await Coran114Store.charger();
    if (mounted) setState(() {
      _favoris = favoris;
      _corpus = corpus;
      _chargement = false;
    });
  }

  String _nom(int numero) => _corpus?.trouver(numero)?.nom ?? switch (numero) {
        1 => 'Al-Fatiha',
        112 => 'Al-Ikhlas',
        113 => 'Al-Falaq',
        114 => 'An-Nas',
        _ => 'Sourate $numero',
      };

  @override
  Widget build(BuildContext context) {
    final items = _favoris.map((value) {
      final n = value.split(':').map(int.parse).toList();
      return (sourate: n[0], verset: n[1]);
    }).toList()
      ..sort((a, b) {
        final cmp = a.sourate.compareTo(b.sourate);
        return cmp != 0 ? cmp : a.verset.compareTo(b.verset);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: _navy,
        foregroundColor: Colors.white,
      ),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: Text(
                      'Aucun favori pour le moment.\n\nOuvre une sourate et touche l’étoile d’un verset.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: const Color(0xFF113454),
                      child: ListTile(
                        key: Key('favori_${item.sourate}_${item.verset}'),
                        leading: const Icon(Icons.star, color: _cyan),
                        title: Text(_nom(item.sourate),
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text('Verset ${item.verset}',
                            style: const TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          tooltip: 'Supprimer ce favori',
                          icon: const Icon(Icons.delete_outline, color: _cyan),
                          onPressed: () async {
                            await FavorisStore.supprimer(item.sourate, item.verset);
                            await _actualiser();
                          },
                        ),
                        onTap: () async {
                          await widget.onOuvrir(item.sourate, item.verset);
                          await _actualiser();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
