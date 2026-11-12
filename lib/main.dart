import 'package:flutter/material.dart';

void main() => runApp(const SazotechCoranApp());

const _navy = Color(0xFF061528);
const _blue = Color(0xFF0875D7);
const _cyan = Color(0xFF00D4F0);
const _softWhite = Color(0xFFE9F5FF);

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

class FatihaScreen extends StatelessWidget {
  const FatihaScreen({super.key});

  // Sourate 1, versets 1 à 7 (écriture arabe vocalisée).
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
          for (int index = 0; index < versets.length; index++) ...[
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
                    versets[index],
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
            'Prochaine étape : écouter la récitation et sauvegarder la progression.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9CBFD2), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
