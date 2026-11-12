import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const SazotechCoranApp());

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);
const _softWhite = Color(0xFFE9F5FF);
// Recitation audio importee localement pour le prototype (pas de reseau requis a la lecture).
const _audioAsset = 'assets/audio/al_fatiha.mp3';

class SazotechCoranApp extends StatelessWidget {
  const SazotechCoranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAZOTECH Coran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _cyan,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: _navy,
      ),
      home: const AccueilScreen(),
    );
  }
}

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_navy, Color(0xFF07325D), _navy],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_stories_outlined, color: _cyan, size: 26),
                  SizedBox(width: 12),
                  Text(
                    'SAZOTECH',
                    style: TextStyle(
                      color: _softWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Center(
                child: Image.asset(
                  'assets/images/logo_sazotech.png',
                  width: 216,
                  height: 216,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'SAZOTECH CORAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Lire • Écouter • Apprendre',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9DDDEE), fontSize: 15),
              ),
              const SizedBox(height: 37),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF113454),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF19608B)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notre première sourate',
                      style: TextStyle(color: _cyan, fontSize: 14),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'الفَاتِحَة',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Al-Fatiha • 7 versets',
                      style: TextStyle(color: _softWhite, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FatihaScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _cyan,
                    foregroundColor: _navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text(
                    'Lire Al-Fatiha',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Version A • Prototype Android',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF82B4CF), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FatihaScreen extends StatefulWidget {
  const FatihaScreen({super.key});

  // Le texte arabe de l'etape 1 est conserve sans modification.
  static const List<String> versets = [
    'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
    'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
    'ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
    'مَـٰلِكِ يَوْمِ ٱلدِّينِ',
    'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ',
    'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ',
  ];

  @override
  State<FatihaScreen> createState() => _FatihaScreenState();
}

class _FatihaScreenState extends State<FatihaScreen> {
  late final AudioPlayer _player;
  StreamSubscription<PlayerException>? _audioErrorSubscription;
  bool _preparing = false;
  bool _loaded = false;
  String? _error;
  String? _sourceName;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _audioErrorSubscription = _player.errorStream.listen((error) {
      debugPrint('SAZOTECH Coran - erreur de lecture: $error');
      if (!mounted || _preparing) return;
      setState(() {
        _loaded = false;
        _error = 'La lecture locale a été interrompue. Réessaie.';
      });
    });
  }

  Future<void> _toggleAudio() async {
    if (_preparing) return;

    final state = _player.playerState;
    if (state.playing && state.processingState != ProcessingState.completed) {
      await _player.pause();
      return;
    }

    setState(() {
      _preparing = true;
      _error = null;
    });

    try {
      if (!_loaded) {
        await _player.setAsset(_audioAsset).timeout(const Duration(seconds: 15));
        _loaded = true;
        _sourceName = 'Audio local';
      }
      if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      if (!mounted) return;
      // play() se termine quand la lecture s'arrete : ne pas l'attendre ici.
      unawaited(_player.play().catchError((Object error) {
        debugPrint('SAZOTECH Coran - lecture MP3 : $error');
        if (!mounted) return;
        setState(() {
          _loaded = false;
          _error = 'La lecture locale a été interrompue. Réessaie.';
        });
      }));
    } catch (error) {
      debugPrint("SAZOTECH Coran - impossible de charger l'audio: $error");
      _loaded = false;
      _sourceName = null;
      if (mounted) {
        setState(() {
          _error = 'Impossible de charger le MP3 local. Relance le script '
              'installer_audio_hors_ligne.ps1 puis Flutter. '
              'Détails dans le terminal.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _preparing = false);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioErrorSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text('Al-Fatiha'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          const Text(
            'سُورَةُ الْفَاتِحَةِ',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(color: _cyan, fontSize: 28),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sourate 1 • 7 versets',
            textAlign: TextAlign.center,
            style: TextStyle(color: _softWhite, fontSize: 14),
          ),
          const SizedBox(height: 22),
          _buildAudioPlayer(),
          const SizedBox(height: 22),
          for (int index = 0; index < FatihaScreen.versets.length; index++) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF102C4A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF1D5274)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Verset ${index + 1}',
                    style: const TextStyle(color: _cyan, fontSize: 13),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    FatihaScreen.versets[index],
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 13),
          ],
          const SizedBox(height: 12),
          const Text(
            'Texte et audio disponibles hors ligne pour ce prototype.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9CBFD2), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF113454),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF19608B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.headphones_rounded, color: _cyan),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Écouter Al-Fatiha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Récitation : Mishary Rashid Al-Afasy',
            style: TextStyle(color: _softWhite, fontSize: 13),
          ),
          const SizedBox(height: 18),
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            initialData: _player.playerState,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final playing = state?.playing ?? false;
              final completed =
                  state?.processingState == ProcessingState.completed;
              final loading = _preparing ||
                  state?.processingState == ProcessingState.loading ||
                  state?.processingState == ProcessingState.buffering;

              final buttonLabel = loading
                  ? 'Chargement audio…'
                  : completed
                      ? 'Réécouter'
                      : playing
                          ? 'Pause'
                          : 'Lecture';
              final buttonIcon = loading
                  ? Icons.hourglass_top_rounded
                  : completed
                      ? Icons.replay_rounded
                      : playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded;
              return SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _preparing ? null : _toggleAudio,
                  style: FilledButton.styleFrom(
                    backgroundColor: _cyan,
                    foregroundColor: _navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: Icon(buttonIcon),
                  label: Text(
                    buttonLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          StreamBuilder<Duration?>(
            stream: _player.durationStream,
            initialData: _player.duration,
            builder: (context, durationSnapshot) {
              final duration = durationSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: _player.positionStream,
                initialData: _player.position,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  final max = duration.inMilliseconds > 0
                      ? duration.inMilliseconds.toDouble()
                      : 1.0;
                  final value = position.inMilliseconds
                      .toDouble()
                      .clamp(0.0, max)
                      .toDouble();
                  return Column(
                    children: [
                      Slider(
                        value: value,
                        min: 0,
                        max: max,
                        activeColor: _cyan,
                        onChanged: duration > Duration.zero
                            ? (value) => _player.seek(
                                  Duration(milliseconds: value.round()),
                                )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position),
                                style: const TextStyle(color: _softWhite)),
                            Text(_formatDuration(duration),
                                style: const TextStyle(color: _softWhite)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Color(0xFFFFC4C4)),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Source : ${_sourceName ?? 'recitation Al-Afasy'} • lecture hors ligne',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF9CBFD2), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
