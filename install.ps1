param(
    [ValidateSet('2024', '2025', '2026', '2027')]
    [string]$RevitYear = '2025',
    [string]$RevitInstallDir = '',
    [string]$RevitApiPath = '',
    [string]$RevitApiUiPath = ''
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildArgs = @('-RevitYear', $RevitYear)
if ($RevitInstallDir) { $buildArgs += @('-RevitInstallDir', $RevitInstallDir) }
if ($RevitApiPath) { $buildArgs += @('-RevitApiPath', $RevitApiPath) }
if ($RevitApiUiPath) { $buildArgs += @('-RevitApiUiPath', $RevitApiUiPath) }
& (Join-Path $projectRoot 'build.ps1') @buildArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$targetFramework = switch ($RevitYear) {
    '2024' { 'net48' }
    '2027' { 'net10.0-windows' }
    default { 'net8.0-windows' }
}
$output = Join-Path $projectRoot "src\Plyry.Plant3D.Revit.Addin\bin\Release\$targetFramework"
$addinsRoot = Join-Path $env:APPDATA "Autodesk\Revit\Addins\$RevitYear"
$installDir = Join-Path $addinsRoot 'Plyry.Plant3DToRevit'
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Copy-Item -Path (Join-Path $output '*') -Destination $installDir -Recurse -Force

$assemblyPath = Join-Path $installDir 'Plyry.Plant3D.Revit.Addin.dll'
$manifestPath = Join-Path $addinsRoot 'Plyry.Plant3DToRevit.addin'
$manifest = @"
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<RevitAddIns>
  <AddIn Type="Application">
    <Name>Plyry Plant 3D to Revit</Name>
    <Assembly>$assemblyPath</Assembly>
    <AddInId>0E5D57DF-4B5E-4BF2-9F4A-F1873612C803</AddInId>
    <FullClassName>Plyry.Plant3D.Revit.Addin.PlyryApplication</FullClassName>
    <VendorId>PLYR</VendorId>
    <VendorDescription>Plyry</VendorDescription>
  </AddIn>
</RevitAddIns>
"@
Set-Content -LiteralPath $manifestPath -Value $manifest -Encoding UTF8
Write-Output "Installed Plyry Plant 3D to Revit for Revit $RevitYear. Restart Revit to load the add-in."
