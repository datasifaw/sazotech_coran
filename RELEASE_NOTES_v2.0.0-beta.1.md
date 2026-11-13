# SAZOTECH Coran v2.0.0 — Préversion Android

**Tag recommandé :** `v2.0.0-beta.1`  
**Statut :** préversion / démonstration, validation fonctionnelle encore en cours.

## Présentation

Première compilation Android de démonstration de **SAZOTECH Coran**, une application éducative Flutter conçue pour lire, écouter et mémoriser le Coran sur Android.

### Fonctionnalités incluses

- Lecture **hors ligne des 114 sourates en arabe** après préparation du corpus local.
- Recherche par **nom arabe/français ou numéro** de sourate.
- Audio **hors ligne des 4 sourates** Al-Fatiha, Al-Ikhlas, Al-Falaq et An-Nas.
- **Favoris**, reprise au dernier verset consulté et progression de mémorisation.
- **Quiz Al-Fatiha** et mode révélation/masquage des versets.
- **Traduction française** Rachid Maach (QuranEnc) uniquement pour les 4 sourates concernées.
- Identité visuelle **SAZOTECH** : logo, icône Android et écran de démarrage.

### État des vérifications

- ✅ Build Android Release généré avec Flutter (~61,5 Mo dans le journal de compilation).
- ✅ APK installé avec succès sur l'émulateur Pixel 7 (`adb install -r` → `Success`).
- ✅ Commande de lancement envoyée à Android.
- ⚠️ Tests manuels de bout en bout sur l'APK encore à finaliser.
- ⚠️ 8 remarques de style `flutter analyze` (non bloquantes pour ce build).
- ⚠️ Diagnostic de test relatif à `SharedPreferencesAsyncPlatform` à revoir même si les tests se sont terminés avec succès.

### Installation du fichier APK

Si un APK est joint à cette Release après vérification des droits de redistribution :

1. Télécharger `SAZOTECH_Coran_Demo_v2.0.0.apk`.
2. Sur un appareil Android autorisant l'installation de sources externes, installer le fichier.
3. Ouvrir SAZOTECH Coran, puis tester la lecture des sourates et les fonctionnalités disponibles.

**Attention :** fichier de démonstration non destiné au Google Play Store. L'installation peut nécessiter d'autoriser temporairement la source d'installation sur le téléphone.

### Contenus et droits

Les textes, traductions et récitations proviennent de fournisseurs tiers (QuranEnc, Al Quran Cloud et sources audio mentionnées dans les scripts). **Ne pas rendre l'APK téléchargeable publiquement tant que les permissions de redistribution, notamment des MP3 intégrés, ne sont pas vérifiées.** Un brouillon de Release sans pièce jointe APK est la solution recommandée pour l'instant.

### Prochaines améliorations

- Vérification fonctionnelle complète sur l'APK.
- Correction des remarques d'analyse Flutter et des avertissements de test.
- Vérification des droits des contenus et processus de signature avant diffusion large.
- Extension future des traductions et des audios.

---

*SAZOTECH Solutions — Lire • Écouter • Apprendre.*
