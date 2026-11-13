# Publier le README et préparer la Release GitHub

## 1 — Installer la documentation dans le projet

Télécharger `SAZOTECH_Coran_README_RELEASE.zip` dans le dossier Téléchargements,
puis exécuter dans PowerShell :

```powershell
Expand-Archive -LiteralPath "$env:USERPROFILE\Downloads\SAZOTECH_Coran_README_RELEASE.zip" -DestinationPath "C:\sazotech_coran" -Force
```

Ce ZIP ajoute ou remplace uniquement README.md et ajoute les fichiers de documentation ;
il ne touche pas aux fichiers Dart, aux MP3 ni au code Android.

## 2 — Commit et push avec GitHub Desktop

1. Ouvrir GitHub Desktop et sélectionner `sazotech_coran`.
2. Dans Changes, vérifier README.md, docs/images et RELEASE_NOTES...md.
3. Summary : `docs: README et presentation SAZOTECH Coran v2.0`.
4. Cliquer Commit to main puis Push origin.
5. Ouvrir le dépôt sur le site GitHub : le README avec image doit apparaître.

## 3 — Préparer une Release (en brouillon)

1. Sur GitHub, ouvrir le dépôt → Releases → Draft a new release.
2. Choose a tag → Create new tag : `v2.0.0-beta.1` (branche main).
3. Release title : `SAZOTECH Coran v2.0.0 — Préversion Android`.
4. Copier le texte du fichier RELEASE_NOTES_v2.0.0-beta.1.md dans la description :

```powershell
Get-Content -LiteralPath "C:\sazotech_coran\RELEASE_NOTES_v2.0.0-beta.1.md" -Raw -Encoding UTF8 | Set-Clipboard
```

5. Cocher `This is a pre-release`.
6. Cliquer `Save draft` pour l'instant.

## 4 — À propos de l'APK

Fichier local attendu sur ton PC :
`C:\sazotech_coran\dist\SAZOTECH_Coran_Demo_v2.0.0.apk`

Ne pas ajouter l'APK comme asset public avant de vérifier les autorisations de
redistribution des enregistrements audio intégrés et de finir les tests.
Quand les droits sont clarifiés et les tests terminés, tu pourras joindre
l'APK au brouillon puis publier la Release.

Le bouton `Publish release` est sur le site github.com, pas dans GitHub Desktop.
