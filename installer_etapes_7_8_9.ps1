# SAZOTECH Coran - Etapes 7, 8 et 9 : audio (4 sourates) + favoris + traduction.
# Script destine a Windows PowerShell 5.1 ou PowerShell 7.
# Il ne supprime ni projet, ni ancien MP3, ni progression, ni depot Git.
# Les donnees telechargees restent sur VOTRE PC pour un usage educatif personnel.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$audioDir = Join-Path $root 'assets\audio'
$transDir = Join-Path $root 'assets\traductions'
$gitignore = Join-Path $root '.gitignore'
New-Item -ItemType Directory -Force -Path $audioDir,$transDir | Out-Null

Write-Host ''
Write-Host 'SAZOTECH CORAN | Etapes 7 + 8 + 9' -ForegroundColor Cyan
Write-Host "Dossier : $root" -ForegroundColor Gray
Write-Host 'Respect des droits : fichiers MP3 locaux exclus du depot Git.'

# Les audios ne doivent pas etre versionnes sans autorisation de redistribution.
$existing = if (Test-Path -LiteralPath $gitignore) {
    [IO.File]::ReadAllText($gitignore)
} else { '' }
$rules = @('/assets/audio/*.mp3', '/assets/traductions/quranenc_french_rashid.json')
foreach ($rule in $rules) {
    if (-not (@($existing -split '\r?\n' | Where-Object { $_.Trim() -eq $rule }).Count -gt 0)) {
        $existing += "`r`n$rule"
    }
}
[IO.File]::WriteAllText($gitignore, $existing, (New-Object System.Text.UTF8Encoding($false)))

function Test-Mp3([string] $path) {
    if (-not (Test-Path -LiteralPath $path)) { return $false }
    if ((Get-Item -LiteralPath $path).Length -lt 20000) { return $false }
    $stream = [IO.File]::OpenRead($path)
    try {
        [byte[]] $bytes = @(0,0,0)
        if ($stream.Read($bytes, 0, 3) -ne 3) { return $false }
        return ([Text.Encoding]::ASCII.GetString($bytes) -eq 'ID3') -or
               ($bytes[0] -eq 255 -and (($bytes[1] -band 224) -eq 224))
    } finally { $stream.Dispose() }
}

$missing = New-Object System.Collections.Generic.List[string]
$audioList = @(
    @{ number=1; name='Al-Fatiha'; file='al_fatiha.mp3'; padded='001' },
    @{ number=112; name='Al-Ikhlas'; file='al_ikhlas.mp3'; padded='112' },
    @{ number=113; name='Al-Falaq'; file='al_falaq.mp3'; padded='113' },
    @{ number=114; name='An-Nas'; file='an_nas.mp3'; padded='114' }
)

foreach ($item in $audioList) {
    $target = Join-Path $audioDir $item.file
    if (Test-Mp3 $target) {
        Write-Host "MP3 deja present : $($item.name)" -ForegroundColor Green
        continue
    }
    $urls = @(
      "https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/$($item.number).mp3",
      "https://cdn.islamic.network/quran/audio-surah/64/ar.alafasy/$($item.number).mp3",
      "https://cdn.mp3quran.net/audio/mishary-alafasy/r1/$($item.padded).mp3"
    )
    $success = $false
    foreach ($url in $urls) {
        $part = "$target.part"
        if (Test-Path -LiteralPath $part) { Remove-Item -LiteralPath $part -Force }
        try {
            Write-Host "Telechargement audio : $($item.name)..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $part -UseBasicParsing -TimeoutSec 45 -MaximumRedirection 5 -ErrorAction Stop
            if (-not (Test-Mp3 $part)) {
                throw 'La reponse ne correspond pas a un MP3 valide.'
            }
            Move-Item -LiteralPath $part -Destination $target -Force
            Write-Host "Audio OK : $($item.file)" -ForegroundColor Green
            $success = $true
            break
        } catch {
            Write-Host "  Source indisponible : $($_.Exception.Message)" -ForegroundColor Yellow
        } finally {
            if (Test-Path -LiteralPath $part) { Remove-Item -LiteralPath $part -Force }
        }
    }
    if (-not $success) { $missing.Add($item.name) }
}

Write-Host ''
Write-Host 'Traduction francaise : QuranEnc / Rachid Maach...' -ForegroundColor Cyan
$translationOk = $false
$translationFile = Join-Path $transDir 'quranenc_french_rashid.json'
try {
    $catalog = Invoke-RestMethod -Uri 'https://quranenc.com/api/v1/translations/list/fr?localization=fr' -TimeoutSec 45 -ErrorAction Stop
    $editions = if ($null -ne $catalog.translations) { @($catalog.translations) } else { @($catalog) }
    $edition = $editions | Where-Object { $_.key -eq 'french_rashid' } | Select-Object -First 1
    if ($null -eq $edition) { throw 'Edition french_rashid absente du catalogue QuranEnc.' }
    $sourates = [ordered]@{}
    $counts = @{ '1'=7; '112'=4; '113'=5; '114'=6 }
    foreach ($number in @(1,112,113,114)) {
        $url = "https://quranenc.com/api/v1/translation/sura/french_rashid/$number"
        $response = Invoke-RestMethod -Uri $url -TimeoutSec 45 -ErrorAction Stop
        $rows = if ($null -ne $response.result) { @($response.result) } else { @($response) }
        $versets = @($rows | Sort-Object { [int]$_.aya })
        if ($versets.Count -ne $counts["$number"]) {
            throw "Nombre incorrect de versets recus pour la sourate $number."
        }
        foreach ($verse in $versets) {
            if ([string]::IsNullOrWhiteSpace([string]$verse.translation)) {
                throw "Traduction vide pour la sourate $number."
            }
        }
        # Conserver integralement les objets API originaux, avec notes et metadonnees.
        $sourates["$number"] = $versets
        Write-Host "  Sourate $number : $($versets.Count) versets" -ForegroundColor Green
    }
    $payload = [ordered]@{
        edition_key = [string]$edition.key
        title = [string]$edition.title
        description = [string]$edition.description
        version = [string]$edition.version
        last_update = $edition.last_update
        source = 'https://quranenc.com/fr/browse/french_rashid'
        publisher = 'QuranEnc.com'
        sourates = $sourates
    }
    if ([string]::IsNullOrWhiteSpace($payload.version)) {
        throw 'Version de traduction indisponible, attribution incomplete.'
    }
    $serialized = ConvertTo-Json -InputObject $payload -Depth 16
    $temp = "$translationFile.part"
    [IO.File]::WriteAllText($temp, $serialized, (New-Object System.Text.UTF8Encoding($false)))
    Move-Item -LiteralPath $temp -Destination $translationFile -Force
    Write-Host "Traduction OK : QuranEnc / $($edition.title) / version $($edition.version)" -ForegroundColor Green
    $translationOk = $true
} catch {
    Write-Host "Traduction non telechargee : $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Consulte https://quranenc.com/fr/browse/french_rashid pour la disponibilite.' -ForegroundColor Yellow
    $part = "$translationFile.part"
    if (Test-Path -LiteralPath $part) { Remove-Item -LiteralPath $part -Force }
}

Write-Host ''
if ($missing.Count -eq 0 -and $translationOk) {
    Write-Host 'SUCCES : les 4 audios et les 4 traductions sont prets sur ce PC.' -ForegroundColor Green
    Write-Host 'Lance : flutter pub get' -ForegroundColor Green
    Write-Host 'Puis   : flutter run -d emulator-5554' -ForegroundColor Green
} else {
    if ($missing.Count -gt 0) {
        Write-Host "MP3 non telecharges : $($missing -join ', ')" -ForegroundColor Red
    }
    if (-not $translationOk) { Write-Host 'Traduction indisponible pour ce test.' -ForegroundColor Red }
    Write-Host 'Le code peut demarrer, mais les contenus non telecharges manqueront.' -ForegroundColor Yellow
    exit 1
}
