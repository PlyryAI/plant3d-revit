param(
    [ValidateSet('2024', '2025', '2026', '2027')]
    [string]$RevitYear = '2025',
    [string]$RevitInstallDir = '',
    [string]$RevitApiPath = '',
    [string]$RevitApiUiPath = ''
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildArgs = @('build', (Join-Path $projectRoot 'Plant3DToRevit.sln'), '--configuration', 'Release', "-p:RevitYear=$RevitYear")
if ($RevitInstallDir) { $buildArgs += "-p:RevitInstallDir=$RevitInstallDir" }
if ($RevitApiPath) { $buildArgs += "-p:RevitApiPath=$RevitApiPath" }
if ($RevitApiUiPath) { $buildArgs += "-p:RevitApiUiPath=$RevitApiUiPath" }

& dotnet @buildArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
