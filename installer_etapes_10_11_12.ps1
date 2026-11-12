# SAZOTECH Coran - Etapes 10 + 11 + 12
# Installation des 114 sourates Uthmani Hafs (6236 versets), noms francais/arabe.
# Aucune modification manuelle des fichiers Dart necessaire.
# A executer dans Windows PowerShell 5.1 ou PowerShell 7.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$destDir = Join-Path $root 'assets\quran'
$destFile = Join-Path $destDir 'coran_114.json'
$tempDir = Join-Path $env:TEMP ('sazotech_coran_114_' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $destDir -Force | Out-Null
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
# Exclure seulement les donnees a recuperer localement et l'APK final de GitHub.
$gitignore = Join-Path $root '.gitignore'
$existingIgnore = if (Test-Path -LiteralPath $gitignore) {
  [IO.File]::ReadAllText($gitignore)
} else { '' }
foreach ($rule in @('/assets/quran/coran_114.json', '/dist/*.apk')) {
  if (@($existingIgnore -split '\r?\n' | Where-Object { $_.Trim() -eq $rule }).Count -eq 0) {
    $existingIgnore += "`r`n$rule"
  }
}
[IO.File]::WriteAllText($gitignore, $existingIgnore, (New-Object System.Text.UTF8Encoding($false)))

function Assert-Corpus($obj) {
  if ($null -eq $obj -or $null -eq $obj.sourates) { throw 'Corpus JSON invalide.' }
  if (@($obj.sourates).Count -ne 114) { throw 'Le corpus doit contenir 114 sourates.' }
  $total = 0
  for ($i=1; $i -le 114; $i++) {
    $s = @($obj.sourates)[$i - 1]
    if ([int]$s.numero -ne $i -or @($s.versets).Count -lt 1) {
      throw "Sourate ou versets manquants : $i"
    }
    for ($v=0; $v -lt @($s.versets).Count; $v++) {
      if ([string]::IsNullOrWhiteSpace([string]$s.versets[$v])) {
        throw "Verset vide dans la sourate $i"
      }
    }
    $total += @($s.versets).Count
  }
  if ($total -ne 6236) { throw "Total de versets incorrect : $total (6236 attendus)." }
}

function Get-QuranEncNames([string] $iso) {
  $url = "https://quranenc.com/api/v1/translations/sowar_names?iso_code=$iso"
  return Invoke-RestMethod -Uri $url -TimeoutSec 50 -ErrorAction Stop
}

function Build-FromQuranEnc([string] $tmp) {
  Write-Host 'Source principale : QuranEnc / Uthmani Hafs ...' -ForegroundColor Cyan
  $zip = Join-Path $tmp 'Hafs_20.zip'
  $expanded = Join-Path $tmp 'hafs'
  Invoke-WebRequest -Uri 'https://quranenc.com/downloads/assets/Hafs_20.zip' -OutFile $zip -TimeoutSec 110 -UseBasicParsing -ErrorAction Stop
  Expand-Archive -LiteralPath $zip -DestinationPath $expanded -Force
  $csv = Get-ChildItem -LiteralPath $expanded -Recurse -File -Filter 'Quran_text.csv' | Select-Object -First 1
  if ($null -eq $csv) { throw 'Fichier Quran_text.csv absent de Hafs_20.zip.' }
  $rows = @(Import-Csv -LiteralPath $csv.FullName -Encoding UTF8)
  if ($rows.Count -ne 6236) { throw "Nombre de lignes CSV inattendu : $($rows.Count)" }
  if ($null -eq $rows[0].sura -or $null -eq $rows[0].aya -or $null -eq $rows[0].uthmani) {
    throw 'Colonnes du CSV inattendues (sura, aya, uthmani).'
  }
  $fr = Get-QuranEncNames 'fr'
  $ar = Get-QuranEncNames 'ar'
  $data = New-Object 'System.Collections.Generic.List[object]'
  foreach ($i in 1..114) {
    $subset = @($rows | Where-Object { [int]$_.sura -eq $i } | Sort-Object { [int]$_.aya })
    $n = 0
    $verses = New-Object 'System.Collections.Generic.List[string]'
    foreach ($row in $subset) {
      $n++
      if ([int]$row.aya -ne $n) { throw "Ordre des versets invalide : $i`:$n" }
      $verses.Add([string]$row.uthmani)
    }
    $nameFr = [string]$fr.PSObject.Properties["$i"].Value
    $nameAr = [string]$ar.PSObject.Properties["$i"].Value
    if ([string]::IsNullOrWhiteSpace($nameFr) -or [string]::IsNullOrWhiteSpace($nameAr)) {
      throw "Noms de sourate manquants pour $i"
    }
    $data.Add([pscustomobject][ordered]@{
      numero = $i; nom = $nameFr; nomArabe = $nameAr;
      versets = @($verses.ToArray())
    })
  }
  return [pscustomobject][ordered]@{
    source = 'QuranEnc - Uthmani Hafs (KFGQPC), Quran_text.csv'
    source_url = 'https://quranenc.com/fr/home/api'
    sourates = @($data.ToArray())
  }
}

function Build-FromAlQuranCloud() {
  Write-Host 'Source de secours : Al Quran Cloud / quran-uthmani ...' -ForegroundColor Yellow
  $api = Invoke-RestMethod -Uri 'https://api.alquran.cloud/v1/quran/quran-uthmani' -TimeoutSec 110 -ErrorAction Stop
  if ($api.code -ne 200 -or $null -eq $api.data.surahs) { throw 'Reponse API incorrecte.' }
  $list = New-Object 'System.Collections.Generic.List[object]'
  foreach ($s in @($api.data.surahs)) {
    $verses = New-Object 'System.Collections.Generic.List[string]'
    $n = 0
    foreach ($a in @($s.ayahs)) {
      $n++
      if ([int]$a.numberInSurah -ne $n) { throw "Verset manquant $($s.number):$n" }
      $verses.Add([string]$a.text)
    }
    $list.Add([pscustomobject][ordered]@{
      numero = [int]$s.number
      nom = [string]$s.englishName
      nomArabe = [string]$s.name
      versets = @($verses.ToArray())
    })
  }
  return [pscustomobject][ordered]@{
    source = 'Al Quran Cloud - Quran Uthmani'
    source_url = 'https://api.alquran.cloud/v1/quran/quran-uthmani'
    sourates = @($list.ToArray())
  }
}

try {
  Write-Host ''
  Write-Host 'SAZOTECH CORAN - INSTALLATION DES 114 SOURATES' -ForegroundColor Cyan
  Write-Host "Projet : $root" -ForegroundColor Gray
  if (Test-Path -LiteralPath $destFile) {
    try {
      $old = Get-Content -LiteralPath $destFile -Encoding UTF8 -Raw | ConvertFrom-Json
      Assert-Corpus $old
      Write-Host 'Le corpus complet est deja present : 114 sourates et 6236 versets.' -ForegroundColor Green
      Write-Host 'Tu peux passer au script creer_apk_sazotech.ps1.' -ForegroundColor Cyan
      exit 0
    } catch {
      Write-Host 'Ancien fichier incomplet : nouveau telechargement.' -ForegroundColor Yellow
    }
  }
  try {
    $payload = Build-FromQuranEnc $tempDir
  } catch {
    Write-Host "QuranEnc temporairement indisponible : $($_.Exception.Message)" -ForegroundColor Yellow
    $payload = Build-FromAlQuranCloud
  }
  Assert-Corpus $payload
  $staged = Join-Path $tempDir 'coran_114.json'
  $json = ConvertTo-Json -InputObject $payload -Depth 16
  [IO.File]::WriteAllText($staged, $json, (New-Object System.Text.UTF8Encoding($false)))
  $check = Get-Content -LiteralPath $staged -Encoding UTF8 -Raw | ConvertFrom-Json
  Assert-Corpus $check
  Move-Item -LiteralPath $staged -Destination $destFile -Force
  Write-Host ''
  Write-Host 'SUCCES : 114 sourates, 6236 versets !' -ForegroundColor Green
  Write-Host "Source : $($payload.source)" -ForegroundColor Cyan
  Write-Host "SHA256 : $((Get-FileHash -LiteralPath $destFile -Algorithm SHA256).Hash)" -ForegroundColor Gray
  Write-Host 'Tu peux maintenant lancer creer_apk_sazotech.ps1.' -ForegroundColor Green
} catch {
  Write-Host ''
  Write-Host "ERREUR : $($_.Exception.Message)" -ForegroundColor Red
  Write-Host 'Le code precedent, les MP3 et les favoris ne sont pas supprimes.' -ForegroundColor Yellow
  exit 1
} finally {
  if (Test-Path -LiteralPath $tempDir) {
    Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}
