# Script to remove hardcoded credentials from the codebase

$filesToFix = @(
    "cmd\idcheck\main.go",
    "cmd\standalone\main.go",
    "cmd\fixedbot\main.go",
    "cmd\simplebot\main.go"
)

Write-Host "Removing hardcoded credentials from codebase..." -ForegroundColor Green

foreach ($file in $filesToFix) {
    $filePath = Join-Path -Path (Get-Location).Path -ChildPath $file
    
    if (Test-Path -Path $filePath) {
        Write-Host "Processing $file..." -ForegroundColor Yellow
        
        # Read file content
        $content = Get-Content -Path $filePath -Raw
        
        # Replace hardcoded bot tokens with placeholder
        $content = $content -replace '("|\s)([0-9]{8,10}):([A-Za-z0-9_-]{35})("|\s)', '$1"YOUR_BOT_TOKEN_HERE"$4'
        
        # Replace hardcoded app IDs
        $content = $content -replace 'appID\s:=\s22806755', 'appID := 0 // Replace with your Telegram App ID'
        $content = $content -replace 'AppId:\s+22806755', 'AppId: 0, // Replace with your Telegram App ID'
        
        # Replace hardcoded app hashes
        $content = $content -replace 'appHash\s:=\s"c6c12dbbee8bac63e9091dbaf6ef3b1d"', 'appHash := "" // Replace with your Telegram App Hash'
        $content = $content -replace 'AppHash:\s+"c6c12dbbee8bac63e9091dbaf6ef3b1d"', 'AppHash: "", // Replace with your Telegram App Hash'
        
        # Write updated content back to file
        Set-Content -Path $filePath -Value $content
        
        Write-Host "Cleaned $file" -ForegroundColor Green
    } else {
        Write-Host "File not found: $file" -ForegroundColor Red
    }
}

# Also check backup directories
$backupDirs = @(
    "backup_2025_05_10",
    "backup_2025_05_10_final"
)

foreach ($dir in $backupDirs) {
    $dirPath = Join-Path -Path (Get-Location).Path -ChildPath $dir
    
    if (Test-Path -Path $dirPath) {
        Write-Host "Processing backup directory $dir..." -ForegroundColor Yellow
        
        $backupFiles = Get-ChildItem -Path $dirPath -Filter "*.go" -Recurse
        
        foreach ($file in $backupFiles) {
            Write-Host "Processing backup file $($file.Name)..." -ForegroundColor Yellow
            
            # Read file content
            $content = Get-Content -Path $file.FullName -Raw
            
            # Replace hardcoded bot tokens with placeholder
            $content = $content -replace '("|\s)([0-9]{8,10}):([A-Za-z0-9_-]{35})("|\s)', '$1"YOUR_BOT_TOKEN_HERE"$4'
            
            # Replace hardcoded app IDs
            $content = $content -replace 'appID\s:=\s22806755', 'appID := 0 // Replace with your Telegram App ID'
            $content = $content -replace 'AppId:\s+22806755', 'AppId: 0, // Replace with your Telegram App ID'
            
            # Replace hardcoded app hashes
            $content = $content -replace 'appHash\s:=\s"c6c12dbbee8bac63e9091dbaf6ef3b1d"', 'appHash := "" // Replace with your Telegram App Hash'
            $content = $content -replace 'AppHash:\s+"c6c12dbbee8bac63e9091dbaf6ef3b1d"', 'AppHash: "", // Replace with your Telegram App Hash'
            
            # Write updated content back to file
            Set-Content -Path $file.FullName -Value $content
            
            Write-Host "Cleaned backup file $($file.Name)" -ForegroundColor Green
        }
    }
}

Write-Host "Credentials cleanup complete!" -ForegroundColor Green
Write-Host "Now commit and push these changes to GitHub" -ForegroundColor Yellow
