# SAZOTECH Coran : personnalisation du launcher et creation d'un APK de demonstration.
# Compilation a lancer sous Windows 11 avec Flutter et Android SDK deja installes.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root
function Verifier([string]$quoi) {
  if ($LASTEXITCODE -ne 0) { throw "Echec : $quoi (code $LASTEXITCODE)" }
}
try {
  Write-Host 'SAZOTECH CORAN | TESTS ET APK' -ForegroundColor Cyan
  if (-not (Test-Path -LiteralPath '.\assets\quran\coran_114.json')) {
    throw 'Le corpus arabe manque. Lance dabord installer_etapes_10_11_12.ps1.'
  }
  foreach ($file in @('al_fatiha.mp3','al_ikhlas.mp3','al_falaq.mp3','an_nas.mp3')) {
    if (-not (Test-Path -LiteralPath (Join-Path 'assets\audio' $file))) {
      throw "Audio manquant : $file. Relance installer_etapes_7_8_9.ps1."
    }
  }
  # Garder l'identifiant Android existant pour preserver les favoris/progression.
  # Modifier seulement le nom visible sous l'icone Android.
  $manifest = Join-Path $root 'android\app\src\main\AndroidManifest.xml'
  if (-not (Test-Path -LiteralPath $manifest)) { throw 'AndroidManifest.xml introuvable.' }
  $xml = [IO.File]::ReadAllText($manifest)
  if ($xml -notmatch 'android:label="[^"]*"') { throw 'Etiquette Android introuvable dans AndroidManifest.xml.' }
  $xml = [regex]::Replace($xml, 'android:label="[^"]*"', 'android:label="SAZOTECH Coran"')
  [IO.File]::WriteAllText($manifest, $xml, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host '1/6 - Dependances Flutter...' -ForegroundColor Cyan
  & flutter pub get; Verifier 'flutter pub get'
  Write-Host '2/6 - Icone Android SAZOTECH...' -ForegroundColor Cyan
  & dart run flutter_launcher_icons; Verifier 'flutter_launcher_icons'
  Write-Host '3/6 - Ecran de demarrage SAZOTECH...' -ForegroundColor Cyan
  & dart run flutter_native_splash:create; Verifier 'flutter_native_splash'
  Write-Host '4/6 - Analyse Flutter...' -ForegroundColor Cyan
  & flutter analyze --no-fatal-infos --no-fatal-warnings; Verifier 'flutter analyze'
  Write-Host '5/6 - Tests Flutter...' -ForegroundColor Cyan
  & flutter test; Verifier 'flutter test'
  Write-Host '6/6 - Construction APK release...' -ForegroundColor Cyan
  & flutter build apk --release; Verifier 'flutter build apk'
  $apk = Join-Path $root 'build\app\outputs\flutter-apk\app-release.apk'
  if (-not (Test-Path -LiteralPath $apk)) { throw "APK introuvable : $apk" }
  $dist = Join-Path $root 'dist'
  New-Item -ItemType Directory -Force -Path $dist | Out-Null
  $target = Join-Path $dist 'SAZOTECH_Coran_Demo_v2.0.0.apk'
  Copy-Item -LiteralPath $apk -Destination $target -Force
  Write-Host ''
  Write-Host 'SUCCES ! APK cree : ' -ForegroundColor Green
  Write-Host $target -ForegroundColor Cyan
  Write-Host 'Ceci est un APK pour TEST, pas une publication Play Store.' -ForegroundColor Yellow
  Write-Host 'Confirme les droits sur les recitations avant partage public.' -ForegroundColor Yellow
} catch {
  Write-Host ''
  Write-Host "ECHEC : $($_.Exception.Message)" -ForegroundColor Red
  Write-Host 'Ne supprime pas le projet. Copie le message dans ChatGPT.' -ForegroundColor Yellow
  exit 1
}
