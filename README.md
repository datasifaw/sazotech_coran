<div align="center">

# 📖 SAZOTECH CORAN

### Lire · Écouter · Apprendre

**Application éducative du Coran pour Android, développée avec Flutter et Dart.**

![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Plateforme-Android-3DDC84?logo=android&logoColor=white)
![Version](https://img.shields.io/badge/Version-2.0.0-00BBD6)
![Statut](https://img.shields.io/badge/Statut-Prototype%20Android-64748B)

![Visuel de présentation de SAZOTECH Coran](docs/images/sazotech-coran-presentation.png)

*Illustration promotionnelle, non contractuelle : l'interface installée peut différer de l'image.*

</div>

## 🌙 Présentation

**SAZOTECH Coran** est un projet Android éducatif conçu pour accompagner la **lecture**, l'**écoute** et la **mémorisation** du Coran. Il propose une interface en français, un texte coranique en arabe et une expérience centrée sur l'apprentissage, avec une identité graphique bleu nuit et cyan.

La version **2.0.0** du prototype a été **compilée en APK release** et **installée avec succès sur un émulateur Android Pixel 7**. Il reste à terminer la validation fonctionnelle complète avant une distribution publique.

## ✨ Fonctionnalités

| Fonctionnalité | Contenu de la V2.0 |
| :--- | :--- |
| 📚 **114 sourates** | Texte arabe consultable hors ligne après préparation du corpus sur le PC |
| 🔎 **Recherche** | Par numéro et par nom de sourate |
| 🎧 **Audio hors ligne** | Lecture / pause / réécoute de **4 sourates** : Al-Fatiha (1), Al-Ikhlas (112), Al-Falaq (113), An-Nas (114) |
| 🇫🇷 **Traduction française** | Traduction Rachid Maach disponible pour ces **4 sourates**, après installation du pack local |
| ⭐ **Favoris et marque-pages** | Enregistrement et consultation des versets favoris |
| 🔖 **Reprise de lecture** | Dernier verset consulté sauvegardé localement |
| 🧠 **Mémorisation** | Masquer / révéler les versets et marquer les sourates apprises |
| 📊 **Suivi** | Progression des sourates mémorisées sur 114 |
| 🏆 **Quiz** | Quiz de mémorisation d'Al-Fatiha avec meilleur score local |
| 🎨 **Identité SAZOTECH** | Logo, icône Android, écran de démarrage et thème bleu/cyan |

> **Périmètre actuel :** les 110 autres sourates n'ont pas encore d'audio hors ligne ni de traduction française intégrés. L'application utilise des fichiers locaux préparés sur le PC de développement ; certains sont volontairement exclus du dépôt Git.

## 🛠️ Stack technique

- **Flutter / Dart** — application mobile et interface utilisateur.
- **Android Studio / Android SDK** — compilation Android et émulateur Pixel 7.
- **VS Code** — environnement de développement.
- **`just_audio`** — lecteur des enregistrements audio locaux.
- **`shared_preferences`** — favoris, progression, quiz et suivi conservés sur l'appareil.
- **Git et GitHub Desktop** — historique, commits et push.
- **PowerShell** — préparation des contenus et génération de l'APK.

**Pas de backend, Docker, MySQL ni compte utilisateur nécessaires** pour le prototype.

## 🚀 Installation et exécution (Windows 11)

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install/windows/mobile) avec Dart.
- [Android Studio](https://developer.android.com/studio) et Android SDK.
- [Visual Studio Code](https://code.visualstudio.com/) et extension Flutter.
- Git ou GitHub Desktop.

Cloner ce dépôt avec GitHub Desktop, puis ouvrir un terminal **PowerShell** à sa racine. Les commandes ci-dessous utilisent le chemin de développement historique `C:\sazotech_coran` : adaptez-le si nécessaire.

```powershell
cd C:\sazotech_coran
flutter doctor
```

### 1. Préparer les contenus locaux

Une connexion Internet est nécessaire **sur le PC pendant cette préparation** :

```powershell
# Audio des quatre sourates et traduction française
powershell -NoProfile -ExecutionPolicy Bypass -File .\installer_etapes_7_8_9.ps1

# Corpus arabe des 114 sourates (contrôle du nombre de versets)
powershell -NoProfile -ExecutionPolicy Bypass -File .\installer_etapes_10_11_12.ps1
```

Le script du corpus contrôle **114 sourates et 6 236 versets** avant de rendre les données disponibles à l'application. Les fichiers MP3, le corpus JSON et le pack de traduction sont préparés localement ; leurs téléchargements peuvent dépendre de la disponibilité des fournisseurs.

### 2. Vérifier le projet

```powershell
flutter pub get
flutter analyze
flutter test
```

> Le journal de construction V2.0 signale **8 remarques de style** non bloquantes. Un avertissement relatif à `SharedPreferencesAsyncPlatform` a également été observé dans la sortie des tests, même si leur bilan global indiquait une réussite.

### 3. Tester sur l'émulateur Android

```powershell
flutter emulators --launch Pixel_7
flutter devices
flutter run -d emulator-5554
```

L'identifiant peut varier : utilisez celui affiché par `flutter devices`. Si l'émulateur est déjà ouvert, ne lancez pas une deuxième instance.

## 📦 Construire l'APK de démonstration

```powershell
cd C:\sazotech_coran
powershell -NoProfile -ExecutionPolicy Bypass -File .\creer_apk_sazotech.ps1
```

Après exécution réussie, le script produit :

```text
dist/SAZOTECH_Coran_Demo_v2.0.0.apk
```

Le journal de compilation a confirmé un APK Android release d'environ **61,5 Mo**, installé sur l'émulateur Pixel 7 par la commande ADB avec un résultat **`Success`**.

Pour installer l'APK sur un émulateur déjà démarré :

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" devices
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" -s emulator-5554 install -r "C:\sazotech_coran\dist\SAZOTECH_Coran_Demo_v2.0.0.apk"
```

> **Important :** il s'agit d'un APK de **démonstration**. Il ne doit pas être présenté comme une application Google Play validée, ni distribué publiquement avec ses contenus tiers tant que leurs droits de redistribution et les tests finaux ne sont pas confirmés.

## 🗂️ Organisation du dépôt

```text
sazotech_coran/
├── android/                     # Configuration Android
├── lib/                         # Écrans Flutter, quiz, favoris, audio, mémorisation
├── test/                        # Tests Flutter
├── assets/
│   ├── images/                  # Identité visuelle SAZOTECH
│   ├── audio/                   # MP3 installés localement
│   ├── quran/                   # Corpus arabe téléchargé
│   └── traductions/             # Traduction installée localement
├── docs/images/                 # Visuel de présentation GitHub
├── installer_etapes_7_8_9.ps1
├── installer_etapes_10_11_12.ps1
├── creer_apk_sazotech.ps1
├── pubspec.yaml
└── README.md
```

Les MP3, le corpus `coran_114.json`, le pack local de traduction et les APK générés peuvent être exclus du dépôt via `.gitignore`. Il faut donc lancer les scripts de préparation sur un nouveau PC avant de compiler.

## 📚 Sources, attribution et droits

| Ressource | Source / crédit |
| :--- | :--- |
| **Texte arabe** | Corpus Uthmani Hafs depuis [QuranEnc](https://quranenc.com/fr/home/api), avec recours possible à [Al Quran Cloud](https://alquran.cloud/api) selon le script |
| **Traduction française** | **Rachid Maach**, via [QuranEnc](https://quranenc.com/fr/browse/french_rashid) ; le pack local conserve les informations de version |
| **Récitations** | **Mishary Rashid Al-Afasy**, par les fournisseurs indiqués dans `installer_etapes_7_8_9.ps1` |
| **Logo et identité** | SAZOTECH Solutions |

Les textes coraniques et traductions doivent être reproduits fidèlement, en respectant les conditions et mentions de leurs sources. **Un fichier audio disponible en téléchargement n'est pas automatiquement libre de redistribution.** Les droits sur les contenus tiers restent la propriété de leurs titulaires respectifs.

## ✅ État du projet

- [x] Prototype Flutter avec identité SAZOTECH.
- [x] Bibliothèque de 114 sourates intégrée au code.
- [x] Audio de 4 sourates, favoris, quiz et mémorisation intégrés.
- [x] APK de démonstration compilé.
- [x] APK installé sur émulateur Pixel 7.
- [x] Documentation GitHub et visuel de présentation.
- [ ] Validation manuelle complète de chaque fonctionnalité sur l'APK release.
- [ ] Confirmation des droits de redistribution des récitations avant mise en ligne de l'APK.
- [ ] Publication d'une version signée et préparée pour une boutique Android, si souhaitée.

## 📌 Versionnement et Release

**Version du projet :** `2.0.0+10` (Flutter).  
**Tag de préversion suggéré :** `v2.0.0-beta.1`.

Une Release GitHub en **brouillon** peut présenter le projet sans joindre publiquement l'APK tant que les vérifications ci-dessus ne sont pas achevées.

## 🤝 Contributions

Les suggestions et signalements de problèmes peuvent être proposés via les *Issues* du dépôt si cette fonctionnalité est activée.

**Licence du code :** aucune licence open source n'est attribuée dans ce README. Ne considérez pas le code ni les médias comme librement réutilisables sans autorisation explicite.

---

<div align="center">

****  
*Lire · Écouter · Apprendre*

</div>
