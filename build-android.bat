@echo off
REM Build script for Android APK (Windows)

echo Building Cross-Platform Game APK
echo.

REM Step 1: Build web game
echo Step 1: Building web game...
cd game-web
call npm run build
if errorlevel 1 (
    echo Error building web game
    exit /b 1
)
echo Web build complete
echo.

REM Step 2: Copy to Flutter assets
echo Step 2: Copying to Flutter assets...
cd ..\flutter_android
if exist assets\web (
    rmdir /s /q assets\web
)
mkdir assets\web
xcopy /s /e /y ..\game-web\dist\* assets\web\
echo Assets copied
echo.

REM Step 3: Build APK
echo Step 3: Building Flutter APK...
call flutter pub get
call flutter build apk --release
echo.

echo Build complete!
echo.
echo APK location:
echo    flutter_android\build\app\outputs\flutter-apk\app-release.apk
echo.
