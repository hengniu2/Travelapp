# Script to fix Flutter file locking issues on Windows
# Run this script as Administrator for best results

Write-Host "Fixing Flutter file locking issues..." -ForegroundColor Cyan

# Stop all Java/Gradle processes
Write-Host "`n1. Stopping Java/Gradle processes..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -like "*java*" -or $_.ProcessName -like "*gradle*"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Stop Gradle daemon
Write-Host "2. Stopping Gradle daemon..." -ForegroundColor Yellow
Set-Location "$PSScriptRoot\android"
.\gradlew --stop 2>$null
Set-Location $PSScriptRoot
Start-Sleep -Seconds 2

# Clean Flutter build
Write-Host "3. Cleaning Flutter build..." -ForegroundColor Yellow
flutter clean
Start-Sleep -Seconds 2

# Remove problematic directories
Write-Host "4. Removing build artifacts..." -ForegroundColor Yellow
Remove-Item "$PSScriptRoot\.dart_tool" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\build" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Get dependencies
Write-Host "5. Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "`nDone! Try running 'flutter run' now." -ForegroundColor Green
Write-Host "`nIf issues persist, add Windows Defender exclusions:" -ForegroundColor Yellow
Write-Host "  - $PSScriptRoot\build" -ForegroundColor Gray
Write-Host "  - $PSScriptRoot\.dart_tool" -ForegroundColor Gray
Write-Host "  - C:\Users\$env:USERNAME\AppData\Local\Pub\Cache" -ForegroundColor Gray


