import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);

/// Enregistrements personnels telecharges sur le PC avant la compilation.
const Map<int, String> cheminsAudio = {
  1: 'assets/audio/al_fatiha.mp3',
  112: 'assets/audio/al_ikhlas.mp3',
  113: 'assets/audio/al_falaq.mp3',
  114: 'assets/audio/an_nas.mp3',
};

class AudioSourateWidget extends StatefulWidget {
  const AudioSourateWidget({super.key, required this.numero, required this.nom});
  final int numero;
  final String nom;
  @override
  State<AudioSourateWidget> createState() => _AudioSourateWidgetState();
}

class _AudioSourateWidgetState extends State<AudioSourateWidget> {
  late final AudioPlayer _player;
  bool _charge = false;
  bool _preparation = false;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  Future<void> _basculer() async {
    if (_preparation) return;
    if (_player.playing && _player.processingState != ProcessingState.completed) {
      await _player.pause();
      return;
    }
    setState(() { _preparation = true; _erreur = null; });
    try {
      if (!_charge) {
        await _player.setAsset(cheminsAudio[widget.numero]!)
            .timeout(const Duration(seconds: 15));
        _charge = true;
      }
      if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      if (!mounted) return;
      unawaited(_player.play().catchError((Object error) {
        debugPrint('SAZOTECH audio ${widget.numero}: $error');
        if (mounted) setState(() { _charge = false; _erreur = 'Lecture interrompue.'; });
      }));
    } catch (error) {
      debugPrint('SAZOTECH chargement ${widget.numero}: $error');
      if (mounted) setState(() {
        _charge = false;
        _erreur = 'MP3 local indisponible : relance installer_etapes_7_8_9.ps1 sur ton PC.';
      });
    } finally {
      if (mounted) setState(() => _preparation = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF113454),
        border: Border.all(color: const Color(0xFF19608B)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Icons.headphones, color: _cyan),
            const SizedBox(width: 10),
            Expanded(child: Text('Écouter ${widget.nom}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
          ]),
          const SizedBox(height: 6),
          const Text('Mishary Al-Afasy • Audio hors ligne',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 14),
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            initialData: _player.playerState,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final fini = state?.processingState == ProcessingState.completed;
              final joue = state?.playing ?? false;
              return FilledButton.icon(
                key: Key('audio_${widget.numero}_bouton'),
                onPressed: _preparation ? null : _basculer,
                style: FilledButton.styleFrom(backgroundColor: _cyan, foregroundColor: _navy),
                icon: Icon(_preparation ? Icons.hourglass_top
                    : fini ? Icons.replay : joue ? Icons.pause : Icons.play_arrow),
                label: Text(_preparation ? 'Chargement…'
                    : fini ? 'Réécouter' : joue ? 'Pause' : 'Lecture'),
              );
            },
          ),
          StreamBuilder<Duration?>(
            stream: _player.durationStream,
            initialData: _player.duration,
            builder: (context, d) => StreamBuilder<Duration>(
              stream: _player.positionStream,
              initialData: _player.position,
              builder: (context, p) {
                final total = d.data ?? Duration.zero;
                final current = p.data ?? Duration.zero;
                final max = total.inMilliseconds > 0 ? total.inMilliseconds.toDouble() : 1.0;
                return Slider(
                  value: current.inMilliseconds.toDouble().clamp(0.0, max).toDouble(),
                  max: max,
                  onChanged: total > Duration.zero
                      ? (value) => _player.seek(Duration(milliseconds: value.round()))
                      : null,
                  activeColor: _cyan,
                );
              },
            ),
          ),
          if (_erreur != null) Text(_erreur!,
              style: const TextStyle(color: Color(0xFFFFC4C4), fontSize: 12)),
        ],
      ),
    );
  }
}
