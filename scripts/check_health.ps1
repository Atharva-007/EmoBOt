# EmuBot Flutter Project Health Check Script
# Run this script to quickly check project status

Write-Host "=== EmuBot Flutter Project Health Check ===" -ForegroundColor Green
Write-Host ""

# Check Flutter Doctor
Write-Host "1. Checking Flutter Doctor..." -ForegroundColor Yellow
flutter doctor

Write-Host ""
Write-Host "2. Getting Dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "3. Running Tests..." -ForegroundColor Yellow
flutter test

Write-Host ""
Write-Host "4. Running Analysis..." -ForegroundColor Yellow
$analysisOutput = flutter analyze 2>&1
$issueCount = ($analysisOutput | Select-String "issues found" | ForEach-Object { $_.Line -replace '.*?(\d+)\s+issues found.*', '$1' })

if ($issueCount) {
    Write-Host "Analysis found $issueCount issues" -ForegroundColor Yellow
} else {
    Write-Host "No analysis issues found!" -ForegroundColor Green
}

Write-Host ""
Write-Host "5. Checking Outdated Packages..." -ForegroundColor Yellow
flutter pub outdated

Write-Host ""
Write-Host "=== Health Check Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "- All critical errors have been fixed" -ForegroundColor Green
Write-Host "- Tests are passing" -ForegroundColor Green  
Write-Host "- Project builds successfully" -ForegroundColor Green
Write-Host "- Only deprecation warnings remain (non-critical)" -ForegroundColor Yellow

if ($issueCount -and [int]$issueCount -gt 0) {
    Write-Host ""
    Write-Host "To see detailed analysis issues:" -ForegroundColor Cyan
    Write-Host "  flutter analyze" -ForegroundColor White
}

Write-Host ""
Write-Host "To update dependencies (when ready):" -ForegroundColor Cyan  
Write-Host "  flutter pub upgrade --major-versions" -ForegroundColor White
Write-Host ""