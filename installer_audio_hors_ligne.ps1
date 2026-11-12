# SAZOTECH Coran : preparer l'audio local pour les tests Android.
# Le fichier MP3 est telecharge directement depuis le fournisseur vers VOTRE PC.
# Aucun MP3 n'est inclus dans le ZIP ni pousse vers GitHub.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$audioDir = Join-Path $root 'assets\audio'
$target = Join-Path $audioDir 'al_fatiha.mp3'
$gitignore = Join-Path $root '.gitignore'
New-Item -ItemType Directory -Force -Path $audioDir | Out-Null

# Evite de publier un MP3 sous droits sur GitHub.
$ignoreLine = '/assets/audio/al_fatiha.mp3'
$ignoreText = if (Test-Path $gitignore) { [IO.File]::ReadAllText($gitignore) } else { '' }
if (-not ($ignoreText -split '\r?\n' | Where-Object { $_.Trim() -eq $ignoreLine })) {
    Add-Content -LiteralPath $gitignore -Value "`n# Audio de demonstration : telechargement local uniquement`n$ignoreLine" -Encoding UTF8
    Write-Host 'Regle Git ajoutee pour ne pas publier le MP3.' -ForegroundColor Yellow
}

function Test-Mp3File([string] $path) {
    if (-not (Test-Path -LiteralPath $path)) { return $false }
    if ((Get-Item -LiteralPath $path).Length -lt 20000) { return $false }
    $fs = [IO.File]::OpenRead($path)
    try {
        $bytes = New-Object byte[] 3
        if ($fs.Read($bytes, 0, 3) -ne 3) { return $false }
        $isId3 = ([Text.Encoding]::ASCII.GetString($bytes) -eq 'ID3')
        $isMpeg = ($bytes[0] -eq 255 -and (($bytes[1] -band 224) -eq 224))
        return ($isId3 -or $isMpeg)
    } finally {
        $fs.Dispose()
    }
}

if (Test-Mp3File $target) {
    Write-Host 'Fichier audio local deja present et valide.' -ForegroundColor Green
} else {
    # Editions autorisees en usage personnel et educatif : verifier les droits avant toute distribution d'APK.
    $sources = @(
        @{ name='Al Quran Cloud'; url='https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3' },
        @{ name='MP3Quran'; url='https://cdn.mp3quran.net/audio/mishary-alafasy/r1/001.mp3' }
    )
    $success = $false
    foreach ($source in $sources) {
        $tempFile = "$target.part"
        if (Test-Path $tempFile) { Remove-Item -LiteralPath $tempFile -Force }
        try {
            Write-Host "Telechargement Al-Fatiha depuis $($source.name)..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $source.url -OutFile $tempFile -UseBasicParsing -TimeoutSec 35 -MaximumRedirection 5 -ErrorAction Stop
            if (-not (Test-Mp3File $tempFile)) {
                throw 'La reponse du serveur ne ressemble pas a un fichier MP3 valide.'
            }
            Move-Item -LiteralPath $tempFile -Destination $target -Force
            $success = $true
            Write-Host "Audio pret : $target" -ForegroundColor Green
            break
        } catch {
            Write-Host "Echec $($source.name) : $($_.Exception.Message)" -ForegroundColor Yellow
        } finally {
            if (Test-Path $tempFile) { Remove-Item -LiteralPath $tempFile -Force }
        }
    }
    if (-not $success) {
        Write-Host 'Aucun MP3 telecharge. Teste les liens dans Chrome sur Windows, pas sur le Pixel.' -ForegroundColor Red
        Write-Host 'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3'
        Write-Host 'https://cdn.mp3quran.net/audio/mishary-alafasy/r1/001.mp3'
        throw "Telechargement impossible. Envoie-moi le message d'erreur affiche ci-dessus."
    }
}
Write-Host ''
Write-Host 'Installation terminee. Execute ces commandes :' -ForegroundColor Green
Write-Host 'cd C:\sazotech_coran'
Write-Host 'flutter pub get'
Write-Host 'flutter run -d emulator-5554'
