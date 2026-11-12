import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fond = Color(0xFF061528);
const _cyan = Color(0xFF00D4F0);
const _blanc = Color(0xFFE9F5FF);
const _carte = Color(0xFF113454);
const _bordure = Color(0xFF19608B);
const _cleMeilleurScore = 'sazotech_coran_fatiha_quiz_record_v1';

/// Quiz local : toutes les propositions proviennent directement
/// des sept versets affiches dans l'application (sans modifier le texte).
class LogiqueQuizFatiha {
  static const nombreQuestions = 5;

  /// Index du verset qui vient APRES le verset affiche.
  static int bonneReponse(int numeroQuestion) {
    assert(numeroQuestion >= 0 && numeroQuestion < nombreQuestions);
    return numeroQuestion + 1;
  }

  /// Trois choix differents. L'emplacement de la bonne reponse varie.
  static List<int> choix(int numeroQuestion) {
    assert(numeroQuestion >= 0 && numeroQuestion < nombreQuestions);
    final correct = bonneReponse(numeroQuestion);
    final autre1 = (numeroQuestion + 2) % 7;
    final autre2 = (numeroQuestion + 4) % 7;
    switch (numeroQuestion % 3) {
      case 0:
        return [autre1, correct, autre2];
      case 1:
        return [autre2, autre1, correct];
      default:
        return [correct, autre2, autre1];
    }
  }
}

class QuizFatihaScreen extends StatefulWidget {
  const QuizFatihaScreen({super.key, required this.versets});

  final List<String> versets;

  @override
  State<QuizFatihaScreen> createState() => _QuizFatihaScreenState();
}

class _QuizFatihaScreenState extends State<QuizFatihaScreen> {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  int _question = 0;
  int _score = 0;
  int? _reponseSelectionnee;
  int? _record;
  bool _termine = false;
  bool _scoreNonSauvegarde = false;

  @override
  void initState() {
    super.initState();
    _chargerRecord();
  }

  Future<void> _chargerRecord() async {
    try {
      final record = await _preferences.getInt(_cleMeilleurScore);
      if (mounted) setState(() => _record = record);
    } catch (error) {
      debugPrint('SAZOTECH Coran - lecture record quiz : $error');
    }
  }

  void _choisir(int indexVerset) {
    if (_reponseSelectionnee != null || _termine) return;
    setState(() {
      _reponseSelectionnee = indexVerset;
      if (indexVerset == LogiqueQuizFatiha.bonneReponse(_question)) {
        _score += 1;
      }
    });
  }

  Future<void> _continuer() async {
    if (_reponseSelectionnee == null) return;
    if (_question < LogiqueQuizFatiha.nombreQuestions - 1) {
      setState(() {
        _question++;
        _reponseSelectionnee = null;
      });
      return;
    }
    setState(() => _termine = true);
    if (_score > (_record ?? 0)) {
      try {
        await _preferences.setInt(_cleMeilleurScore, _score);
        if (mounted) setState(() => _record = _score);
      } catch (error) {
        debugPrint('SAZOTECH Coran - sauvegarde record quiz : $error');
        if (mounted) setState(() => _scoreNonSauvegarde = true);
      }
    }
  }

  void _recommencer() {
    setState(() {
      _question = 0;
      _score = 0;
      _reponseSelectionnee = null;
      _termine = false;
      _scoreNonSauvegarde = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fond,
      appBar: AppBar(
        backgroundColor: _fond,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Quiz Al-Fatiha'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 32),
          children: _termine ? _contenuResultat() : _contenuQuestion(),
        ),
      ),
    );
  }

  List<Widget> _contenuQuestion() {
    final options = LogiqueQuizFatiha.choix(_question);
    final bonne = LogiqueQuizFatiha.bonneReponse(_question);
    final repondu = _reponseSelectionnee != null;
    final correct = _reponseSelectionnee == bonne;

    return [
      Row(
        children: [
          const Icon(Icons.school_rounded, color: _cyan),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Question ${_question + 1} / ${LogiqueQuizFatiha.nombreQuestions}',
              style: const TextStyle(color: _blanc, fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          Text('$_score point${_score > 1 ? 's' : ''}',
              style: const TextStyle(color: _cyan)),
        ],
      ),
      const SizedBox(height: 14),
      LinearProgressIndicator(
        value: (_question + 1) / LogiqueQuizFatiha.nombreQuestions,
        color: _cyan,
        backgroundColor: const Color(0xFF24506C),
        minHeight: 7,
        borderRadius: BorderRadius.circular(8),
      ),
      const SizedBox(height: 25),
      const Text(
        'Quel verset vient juste après celui-ci ?',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _carte,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _bordure),
        ),
        child: Text(
          widget.versets[_question],
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _blanc, fontSize: 28, height: 1.85),
        ),
      ),
      const SizedBox(height: 22),
      const Text(
        'Choisis la suite correcte :',
        style: TextStyle(color: _cyan, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      for (final option in options) ...[
        _choixCarte(option, bonne: bonne, repondu: repondu),
        const SizedBox(height: 12),
      ],
      if (repondu) ...[
        const SizedBox(height: 12),
        Text(
          correct ? 'Bravo ! Bonne réponse.' : 'Pas tout à fait. La bonne réponse est encadrée en vert.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: correct ? const Color(0xFF8AE6B3) : const Color(0xFFFFD9A3),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            key: const Key('quiz_next_button'),
            onPressed: _continuer,
            style: FilledButton.styleFrom(backgroundColor: _cyan, foregroundColor: _fond),
            icon: Icon(_question == LogiqueQuizFatiha.nombreQuestions - 1
                ? Icons.emoji_events_outlined : Icons.arrow_forward_rounded),
            label: Text(
              _question == LogiqueQuizFatiha.nombreQuestions - 1 ? 'Voir mon résultat' : 'Question suivante',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      const SizedBox(height: 20),
      const Text(
        'Exercice éducatif hors ligne, fondé sur les versets affichés dans l’application.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF9CBFD2), fontSize: 12),
      ),
    ];
  }

  Widget _choixCarte(int indexVerset, {required int bonne, required bool repondu}) {
    final juste = indexVerset == bonne;
    final choisi = indexVerset == _reponseSelectionnee;
    final couleur = repondu && juste
        ? const Color(0xFF164938)
        : repondu && choisi
            ? const Color(0xFF572E3C)
            : _carte;
    final bord = repondu && juste
        ? const Color(0xFF77E6AA)
        : repondu && choisi
            ? const Color(0xFFFFA7B4)
            : _bordure;
    return Material(
      color: couleur,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: bord, width: repondu && (juste || choisi) ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('quiz_option_$indexVerset'),
        onTap: repondu ? null : () => _choisir(indexVerset),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.versets[indexVerset],
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white, fontSize: 22, height: 1.8),
              ),
              if (repondu && (juste || choisi)) ...[
                const SizedBox(height: 6),
                Text(
                  juste ? 'Bonne réponse • verset ${indexVerset + 1}' : 'Ta réponse',
                  style: TextStyle(
                    color: juste ? const Color(0xFF8AE6B3) : const Color(0xFFFFC4C4),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _contenuResultat() {
    return [
      const SizedBox(height: 40),
      const Icon(Icons.emoji_events_outlined, color: _cyan, size: 74),
      const SizedBox(height: 14),
      const Text(
        'Quiz terminé !',
        textAlign: TextAlign.center,
        style: TextStyle(color: _blanc, fontSize: 25, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 15),
      Text(
        '$_score / ${LogiqueQuizFatiha.nombreQuestions}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: _cyan, fontSize: 48, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 12),
      Text(
        _score == LogiqueQuizFatiha.nombreQuestions
            ? 'Excellent ! Tu connais l’ordre des versets.'
            : 'Continue à t’entraîner avec le mode mémorisation.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: _blanc, fontSize: 15),
      ),
      if (_record != null) ...[
        const SizedBox(height: 18),
        Text(
          'Meilleur score : $_record / ${LogiqueQuizFatiha.nombreQuestions}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: _cyan),
        ),
      ],
      if (_scoreNonSauvegarde) ...[
        const SizedBox(height: 10),
        const Text(
          'Le meilleur score n’a pas pu être enregistré sur ce téléphone.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFFFC4C4)),
        ),
      ],
      const SizedBox(height: 30),
      SizedBox(
        height: 54,
        child: FilledButton.icon(
          onPressed: _recommencer,
          style: FilledButton.styleFrom(backgroundColor: _cyan, foregroundColor: _fond),
          icon: const Icon(Icons.replay_rounded),
          label: const Text('Recommencer', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.home_outlined),
        label: const Text('Retour à l’accueil'),
      ),
    ];
  }
}
