# Fix Windows Defender File Locking Issues

## Problem
Flutter builds fail with "The process cannot access the file because it is being used by another process" errors. This is caused by Windows Defender scanning files during the build process.

## Solution 1: Add Windows Defender Exclusions (RECOMMENDED)

1. **Open Windows Security:**
   - Press `Win + I` to open Settings
   - Go to **Privacy & Security** → **Windows Security** → **Virus & threat protection**
   - Click **Manage settings** under "Virus & threat protection settings"

2. **Add Exclusions:**
   - Scroll down to **Exclusions**
   - Click **Add or remove exclusions**
   - Click **+ Add an exclusion** → **Folder**
   - Add these folders:
     - `D:\Projects\travel\build`
     - `D:\Projects\travel\.dart_tool`
     - `C:\Users\com\AppData\Local\Pub\Cache`
     - `C:\src\flutter` (if Flutter is installed here)

3. **Restart your computer** (optional but recommended)

## Solution 2: Disable Windows Search Indexing

1. Right-click on `D:\Projects\travel` folder
2. Select **Properties**
3. Click **Advanced**
4. Uncheck **"Allow files in this folder to have contents indexed"**
5. Click **OK** and apply to all subfolders

## Solution 3: Use the Fix Script

Run the provided PowerShell script:
```powershell
.\fix-file-locks.ps1
```

Then try:
```powershell
flutter run
```

## Solution 4: Temporary Workaround

If you need to build immediately, use:
```powershell
flutter build apk --debug --target-platform android-arm64
```

This builds for a single architecture and avoids some file locking issues.

## Why This Happens

Windows Defender's real-time protection scans files as they're being written, which can lock them during Flutter's build process. Adding exclusions tells Windows Defender to skip scanning these directories, preventing file locks.


