# Create UserSpace

$UserSpaceRoot = Join-Path $env:USERPROFILE "UserSpace"

if (-not (Test-Path $UserSpaceRoot)) {
    New-Item -ItemType Directory -Path $UserSpaceRoot
    Write-Host "Created UserSpace root: $UserSpaceRoot"
} else {
    Write-Host "UserSpace root already exists: $UserSpaceRoot"
}

$Dirs = @(
    "Assets",
    "Desktop",
    "Documents",
    "Downloads",
    "Games",
    "Music",
    "Pictures",
    "Projects",
    "Resources",
    "Utils",
    "Videos",
    "VSTPlugins"
)

$KnownFolders = @{
    "Desktop"   = "Desktop"
    "Documents" = "Personal"
    "Downloads" = "{374DE290-123F-4565-9164-39C4925E467B}"
    "Pictures"  = "My Pictures"
    "Videos"    = "My Video"
    "Music"     = "My Music"
}

foreach ($d in $Dirs) {

    $OldPath = Join-Path $env:USERPROFILE $d
    $NewPath = Join-Path $UserSpaceRoot $d

    if (-not (Test-Path $NewPath)) {
        New-Item -ItemType Directory -Path $NewPath
        Write-Host "Created: $NewPath"
    }

    if (Test-Path $OldPath) {
        Write-Host "Moving old folder contents: $OldPath → $NewPath"

        try {
            Move-Item -Path (Join-Path $OldPath '*') -Destination $NewPath -Force
            Write-Host "Moved contents successfully."
        }
        catch {
            Write-Host "Failed to move contents of $OldPath. Error: $_"
        }
    }
    else {
        Write-Host "Old folder not found: $OldPath"
    }

    # If this folder is a known folder → update registry
    if ($KnownFolders.ContainsKey($d)) {
        $RegKey = $KnownFolders[$d]
        $RegPath1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

        Write-Host "Updating registry for $d → $NewPath"
        Set-ItemProperty -Path $RegPath1 -Name $RegKey -Value $NewPath
    }
}

Write-Host "All directories processed."

$ShortcutPath = Join-Path $UserSpaceRoot "Desktop\UserSpace.lnk"
$TargetPath = $UserSpaceRoot

if (-not (Test-Path $ShortcutPath)) {
    Write-Host "Creating Desktop shortcut: $ShortcutPath → $TargetPath"

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.WorkingDirectory = $TargetPath
    $Shortcut.IconLocation = "$env:SystemRoot\system32\shell32.dll,4"
    $Shortcut.Save()

    Write-Host "Desktop shortcut created."
} else {
    Write-Host "Desktop shortcut already exists: $ShortcutPath"
}

Write-Host "Refreshing Explorer..."
Stop-Process -Name explorer -Force
Start-Process explorer.exe
Write-Host "Explorer refreshed."