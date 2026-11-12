import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sources et crédits')),
    body: const SingleChildScrollView(padding: EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Texte arabe du Coran', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Le script de préparation installe le texte arabe Uthmani Hafs publié '
          'sur QuranEnc (Complexe Roi Fahd pour l’impression du Saint Coran), '
          'ou utilise l’édition Uthmani d’Al Quran Cloud en cas d’indisponibilité. '
          'Le fichier source est conservé sans modification des versets.'),
        SizedBox(height: 6),
        SelectableText('https://quranenc.com/fr/home/api'),
        SelectableText('https://api.alquran.cloud/v1/quran/quran-uthmani'),
        SizedBox(height: 23),
        Text('Traduction française', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Rachid Maach — QuranEnc. Seuls les textes du paquet de traduction '
          'déjà installé sont affichés, avec attribution.'),
        SelectableText('https://quranenc.com/fr/browse/french_rashid'),
        SizedBox(height: 23),
        Text('Récitation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Mishary Al-Afasy, fichiers locaux installés auparavant pour quatre sourates. '
          'Vérifier les droits de redistribution avant de publier un APK.'),
        SizedBox(height: 23),
        Text('SAZOTECH Coran', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Application éducative de démonstration. Les favoris et la progression '
          'sont stockés localement sur l’appareil.'),
      ])),
  );
}
