Write-Host "Downloads Organizer" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan

$downloadsPath = [Environment]::GetFolderPath('UserProfile') + "\Downloads"
Write-Host "Target: $downloadsPath" -ForegroundColor Yellow

$folders = @{
    "Images"     = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg')
    "Documents"  = @('.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt', '.csv', '.md')
    "Installers" = @('.exe', '.msi', '.apk')
    "Archives"   = @('.zip', '.rar', '.7z', '.tar', '.gz')
    "Audio"      = @('.mp3', '.wav', '.flac', '.ogg')
    "Video"      = @('.mp4', '.mkv', '.avi', '.mov')
}

$movedCount = 0

foreach ($category in $folders.Keys) {
    $categoryPath = Join-Path -Path $downloadsPath -ChildPath $category
    
    $filesToMove = Get-ChildItem -Path $downloadsPath -File | Where-Object { 
        $folders[$category] -contains $_.Extension.ToLower() 
    }

    if ($filesToMove.Count -gt 0) {
        if (-not (Test-Path $categoryPath)) {
            New-Item -ItemType Directory -Path $categoryPath | Out-Null
        }

        foreach ($file in $filesToMove) {
            Move-Item -Path $file.FullName -Destination $categoryPath -Force
            $movedCount++
        }
    }
}

if ($movedCount -gt 0) {
    Write-Host "`nSuccessfully organized $movedCount files into neat folders!" -ForegroundColor Green
} else {
    Write-Host "`nYour Downloads folder is already clean or contains unsupported file types." -ForegroundColor Gray
}

Read-Host "`nPress Enter to exit..."
