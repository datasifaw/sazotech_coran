# SAZOTECH Coran 📖

**Lire • Écouter • Apprendre** — Application éducative du Coran pour Android, développée avec Flutter et Dart.

![Visuel de présentation de SAZOTECH Coran](docs/images/sazotech-coran-presentation.png)

> **État :** prototype Android **2.0.0**, compilé et installé avec succès sur un émulateur Pixel 7. Tests fonctionnels complets et droits de redistribution encore à finaliser. L'image ci-dessus est un **visuel promotionnel**, pas une capture certifiée de la version finale.

## Fonctionnalités

| Fonction | Disponibilité dans le prototype |
| --- | --- |
| **Lecture du Coran** | Texte arabe des **114 sourates**, consultable hors connexion après préparation des données |
| **Recherche** | Par nom de sourate en français/arabe ou par numéro |
| **Audio hors ligne** | Lecture, pause et réécoute pour **Al-Fatiha (1), Al-Ikhlas (112), Al-Falaq (113), An-Nas (114)** |
| **Traduction française** | Rachid Maach (QuranEnc), pour ces **4 sourates seulement**, si le pack local est installé |
| **Favoris** | Ajouter/retirer des versets et les retrouver dans *Mes favoris* |
| **Lecture suivie** | Sauvegarde locale du dernier verset consulté |
| **Mémorisation** | Masquer/révéler les versets ; marquer les sourates apprises et suivre la progression sur 114 |
| **Quiz** | Quiz éducatif d'Al-Fatiha et meilleur score enregistré |
| **Identité SAZOTECH** | Thème bleu nuit/cyan, logo, icône et écran de démarrage Android |

> **Limites actuelles :** il n'y a pas encore d'audio ni de traduction française pour les **110 autres sourates**. Le rendu des 114 sourates dépend du téléchargement du corpus arabe pendant l'installation sur le PC de développement.

## Technologies

- **Flutter / Dart** : application mobile et interface.
- **Android SDK / Android Studio** : compilation et émulateur Android.
- **just_audio** : lecteur de fichiers audio locaux.
- **shared_preferences** : favoris, marque-pages, progression, quiz et suivi de mémorisation stockés sur l'appareil.
- **Git / GitHub** : versionnement du projet.
- **PowerShell** : scripts Windows pour préparer les ressources et générer l'APK.

**Aucun serveur, Docker, MySQL ou compte utilisateur n'est requis** pour le fonctionnement du prototype.

## Préparer le projet sur Windows 11

Prérequis : [Flutter](https://docs.flutter.dev/get-started/install/windows/mobile), Android SDK (via Android Studio), VS Code et Git/GitHub Desktop.

Cloner le dépôt dans un dossier local, puis ouvrir un terminal PowerShell à sa racine. Les commandes ci-dessous supposent que le dossier est `C:\\sazotech_coran` :

```powershell
cd C:\sazotech_coran
flutter doctor

# Télécharger les audios des 4 sourates et la traduction française
powershell -NoProfile -ExecutionPolicy Bypass -File .\installer_etapes_7_8_9.ps1

# Télécharger et contrôler les 114 sourates en arabe
powershell -NoProfile -ExecutionPolicy Bypass -File .\installer_etapes_10_11_12.ps1

flutter pub get
flutter analyze
flutter test
```

Les scripts téléchargent des fichiers depuis leurs fournisseurs respectifs. Ils requièrent une connexion Internet sur le **PC lors de la préparation** et peuvent échouer temporairement si une source est indisponible.

### Lancer sur le Pixel 7 virtuel

```powershell
flutter emulators --launch Pixel_7
flutter devices
flutter run -d emulator-5554
```

Ne lancez qu'un émulateur à la fois. Si son identifiant change, utilisez celui affiché par `flutter devices`.

### Construire l'APK Android de démonstration

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\creer_apk_sazotech.ps1
```

En cas de réussite, le script copie le fichier ici :

```text
dist/SAZOTECH_Coran_Demo_v2.0.0.apk
```

Cet APK est une **version de démonstration**, pas une distribution Play Store prête à publier. Les tests manuels sur téléphone et la vérification des droits des médias restent nécessaires.

## Structure du projet

```text
sazotech_coran/
├── lib/                         # écrans, stockage local, quiz, audio
├── assets/
│   ├── images/                  # logos et icônes
│   ├── audio/                   # MP3 locaux (téléchargés séparément)
│   ├── traductions/             # JSON local (téléchargé séparément)
│   └── quran/                   # texte arabe (téléchargé séparément)
├── docs/images/                 # image de présentation du projet
├── test/                        # tests Flutter
├── installer_etapes_7_8_9.ps1
├── installer_etapes_10_11_12.ps1
└── creer_apk_sazotech.ps1
```

Les fichiers MP3, le corpus arabe local, le pack de traduction et les APK générés peuvent être exclus du dépôt par `.gitignore` ; ils doivent être préparés sur le PC lors d'un nouveau clonage. Vérifiez ce point avant un lancement sur une nouvelle machine.

## Sources et crédits

- **Texte arabe** : corpus Uthmani Hafs proposé par [QuranEnc](https://quranenc.com/fr/home/api) (source principale du script), ou [Al Quran Cloud](https://alquran.cloud/api) en secours. Les scripts contrôlent la présence de 114 sourates et de 6 236 versets.
- **Traduction française (4 sourates)** : **Rachid Maach**, distribuée par [QuranEnc](https://quranenc.com/fr/browse/french_rashid). La version exacte est enregistrée dans les métadonnées du fichier local téléchargé.
- **Récitations (4 sourates)** : **Mishary Rashid Al-Afasy**, fichiers obtenus par les sources mentionnées dans `installer_etapes_7_8_9.ps1`.
- **Identité visuelle** : SAZOTECH Solutions. Le visuel promotionnel de ce dépôt illustre l'application et peut différer de l'interface compilée.

**Droits d'utilisation :** les conditions des fournisseurs de textes, traductions et audios doivent être vérifiées avant redistribution d'un APK public contenant ces ressources. En particulier, la disponibilité d'un MP3 au téléchargement ne vaut pas autorisation de le redistribuer. Aucun droit sur les contenus tiers n'est revendiqué.

## État de la version 2.0.0

- [x] Compilation de l'APK Android de démonstration.
- [x] Installation de l'APK sur l'émulateur Pixel 7.
- [ ] Validation manuelle complète des fonctionnalités sur le binaire de distribution.
- [ ] Vérification des droits de redistribution des contenus avant publication publique de l'APK.
- [ ] Signature et préparation éventuelle pour le Google Play Store.

## Contributions et licence

Projet SAZOTECH en cours de développement. **Aucune licence de code n'est définie ici** : n'en déduisez pas une autorisation générale de réutilisation. Pour contribuer ou demander une autorisation, ouvrez une issue sur ce dépôt si son propriétaire a activé les issues.
