import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const SazotechCoranApp());

const _navy = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);
const _softWhite = Color(0xFFE9F5FF);
// Recitation audio importee localement pour le prototype (pas de reseau requis a la lecture).
const _audioAsset = 'assets/audio/al_fatiha.mp3';
const _lastVerseKey = 'sazotech_coran_al_fatiha_last_verse';

// Une seule valeur enregistree localement : le dernier verset selectionne.
// SharedPreferencesAsync utilise le stockage persistant Android (DataStore).
class _Progression {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<int?> lire() async {
    final verse = await _prefs.getInt(_lastVerseKey);
    if (verse == null || verse < 1 || verse > 7) return null;
    return verse;
  }

  static Future<void> enregistrer(int verse) async {
    if (verse < 1 || verse > 7) return;
    await _prefs.setInt(_lastVerseKey, verse);
  }
}

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

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  int? _dernierVerset;
  String? _erreurProgression;

  @override
  void initState() {
    super.initState();
    _chargerProgression();
  }

  Future<void> _chargerProgression() async {
    try {
      final verse = await _Progression.lire();
      if (!mounted) return;
      setState(() {
        _dernierVerset = verse;
        _erreurProgression = null;
      });
    } catch (error) {
      debugPrint('SAZOTECH Coran - lecture progression : $error');
      if (!mounted) return;
      setState(() {
        _erreurProgression = 'Progression locale indisponible.';
      });
    }
  }

  Future<void> _ouvrirFatiha() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FatihaScreen(initialVerse: _dernierVerset),
      ),
    );
    if (mounted) await _chargerProgression();
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notre première sourate',
                      style: TextStyle(color: _cyan, fontSize: 14),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'الفَاتِحَة',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Al-Fatiha • 7 versets',
                      style: TextStyle(color: _softWhite, fontSize: 16),
                    ),
                    if (_dernierVerset != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.bookmark_added_rounded,
                              color: _cyan, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Dernier verset : $_dernierVerset / 7',
                              style: const TextStyle(
                                  color: _cyan, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: _ouvrirFatiha,
                  style: FilledButton.styleFrom(
                    backgroundColor: _cyan,
                    foregroundColor: _navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(_dernierVerset == null
                      ? Icons.menu_book_rounded
                      : Icons.bookmark_rounded),
                  label: Text(
                    _dernierVerset == null
                        ? 'Lire Al-Fatiha'
                        : 'Reprendre au verset $_dernierVerset',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              if (_erreurProgression != null) ...[
                const SizedBox(height: 12),
                Text(
                  _erreurProgression!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFFFC4C4)),
                ),
              ],
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
  const FatihaScreen({super.key, this.initialVerse});

  final int? initialVerse;

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
  int? _versetSelectionne;
  final List<GlobalKey> _cleVersets =
      List<GlobalKey>.generate(7, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _versetSelectionne = widget.initialVerse;
    if (_versetSelectionne == null) {
      _restaurerProgression();
    } else {
      _allerAuVersetSelectionne();
    }
    _audioErrorSubscription = _player.errorStream.listen((error) {
      debugPrint('SAZOTECH Coran - erreur de lecture: $error');
      if (!mounted || _preparing) return;
      setState(() {
        _loaded = false;
        _error = 'La lecture locale a été interrompue. Réessaie.';
      });
    });
  }

  Future<void> _restaurerProgression() async {
    try {
      final verse = await _Progression.lire();
      if (!mounted) return;
      setState(() => _versetSelectionne = verse);
      _allerAuVersetSelectionne();
    } catch (error) {
      debugPrint('SAZOTECH Coran - restauration progression : $error');
    }
  }

  void _allerAuVersetSelectionne() {
    final verse = _versetSelectionne;
    if (verse == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final verseContext = _cleVersets[verse - 1].currentContext;
      if (verseContext == null) return;
      Scrollable.ensureVisible(
        verseContext,
        duration: const Duration(milliseconds: 400),
        alignment: 0.12,
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _memoriserVerset(int verse) async {
    if (_versetSelectionne == verse) return;
    final ancien = _versetSelectionne;
    setState(() => _versetSelectionne = verse);
    try {
      await _Progression.enregistrer(verse);
    } catch (error) {
      debugPrint('SAZOTECH Coran - sauvegarde progression : $error');
      if (!mounted) return;
      setState(() => _versetSelectionne = ancien);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sauvegarde locale indisponible.')),
      );
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: 14),
          const Text(
            'Touchez un verset pour enregistrer votre position de lecture.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9CBFD2), fontSize: 13),
          ),
          const SizedBox(height: 18),
          for (int index = 0; index < FatihaScreen.versets.length; index++) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _memoriserVerset(index + 1),
                child: Container(
                  key: _cleVersets[index],
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _versetSelectionne == index + 1
                        ? const Color(0xFF174B68)
                        : const Color(0xFF102C4A),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _versetSelectionne == index + 1
                          ? _cyan
                          : const Color(0xFF1D5274),
                      width: _versetSelectionne == index + 1 ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Verset ${index + 1}',
                            style: const TextStyle(color: _cyan, fontSize: 13),
                          ),
                          const Spacer(),
                          if (_versetSelectionne == index + 1) ...[
                            const Icon(Icons.bookmark_added_rounded,
                                color: _cyan, size: 18),
                            const SizedBox(width: 5),
                            const Text('Dernier lu',
                                style: TextStyle(color: _cyan, fontSize: 12)),
                          ],
                        ],
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
              ),
            ),
            const SizedBox(height: 13),
          ],
          const SizedBox(height: 12),
          const Text(
            'Texte, audio et progression disponibles hors ligne.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9CBFD2), fontSize: 13),
          ),
          ],
        ),
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
