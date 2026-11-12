# SAZOTECH Coran - configuration automatique Android pour l'audio en ligne.
# Ce script modifie uniquement AndroidManifest.xml (permission INTERNET).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifest = Join-Path $root 'android\app\src\main\AndroidManifest.xml'
if (-not (Test-Path -LiteralPath $manifest)) {
    throw "AndroidManifest.xml introuvable. Le script doit etre dans C:\sazotech_coran."
}
$content = [System.IO.File]::ReadAllText($manifest)
if ($content.Contains('android.permission.INTERNET')) {
    Write-Host 'Permission INTERNET deja presente : OK' -ForegroundColor Green
} else {
    $opening = [regex]::Match($content, '<manifest\b[^>]*>')
    if (-not $opening.Success) {
        throw 'Balise <manifest> introuvable. Aucun fichier modifie.'
    }
    $backup = Join-Path $env:TEMP 'SAZOTECH_Coran_AndroidManifest_avant_audio.xml'
    [System.IO.File]::Copy($manifest, $backup, $true)
    $permission = "`r`n    <uses-permission android:name=`"android.permission.INTERNET`" />"
    $updated = $content.Insert($opening.Index + $opening.Length, $permission)
    [System.IO.File]::WriteAllText(
        $manifest,
        $updated,
        [System.Text.UTF8Encoding]::new($false)
    )
    Write-Host 'Permission INTERNET ajoutee automatiquement : OK' -ForegroundColor Green
    Write-Host "Sauvegarde de l'ancien manifest : $backup"
}
Write-Host 'Configuration audio terminee. Executer : flutter pub get' -ForegroundColor Cyan
