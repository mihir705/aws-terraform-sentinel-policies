# Run all Sentinel policy unit tests on Windows.
# Usage: .\scripts\test.ps1

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

$sentinel = Get-Command sentinel -ErrorAction SilentlyContinue
if (-not $sentinel) {
    $sentinelPath = Join-Path $env:USERPROFILE "bin\sentinel.exe"
    if (-not (Test-Path $sentinelPath)) {
        Write-Error "Sentinel CLI not found. Install to `$env:USERPROFILE\bin\sentinel.exe or add sentinel to PATH."
    }
    $sentinel = $sentinelPath
}

$policies = (Get-ChildItem policies -Filter *.sentinel).FullName
if ($policies.Count -eq 0) {
    Write-Error "No policies found in .\policies"
}

Write-Host "Running Sentinel tests on $($policies.Count) policies..." -ForegroundColor Cyan
& $sentinel test @policies
exit $LASTEXITCODE
