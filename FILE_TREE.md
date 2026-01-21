# Project File Tree

## Current Clean Structure

```
reactgame/
│
├── 📝 README.md                       # Quick reference & setup guide
├── 📝 PROJECT_STRUCTURE.md            # Complete developer guide
├── 🔨 build-android.bat               # Automated build script
├── 🚫 .gitignore                      # Git ignore rules
│
├── 🎮 game-web/                       # ═══ ALL DEVELOPMENT HERE ═══
│   │
│   ├── 📂 src/                        # Source code
│   │   │
│   │   ├── 🧠 game-core/              # Game Logic Layer
│   │   │   ├── GameEngine.js         # Main game loop coordinator
│   │   │   ├── state/
│   │   │   │   └── GameState.js      # Game state structure
│   │   │   ├── systems/
│   │   │   │   └── PlayerSystem.js   # Player logic
│   │   │   └── save/
│   │   │       └── SaveManager.js    # Persistence system
│   │   │
│   │   ├── 🎨 game-renderer/          # Rendering Layer
│   │   │   ├── PhaserGame.js         # Phaser component wrapper
│   │   │   └── scenes/
│   │   │       └── MainScene.js      # Main game scene
│   │   │
│   │   ├── 🖼️ ui/                     # UI Layer
│   │   │   ├── App.jsx               # Root React component
│   │   │   ├── App.css               # Global styles
│   │   │   └── screens/
│   │   │       ├── StartScreen.jsx   # Title/menu screen
│   │   │       └── GameOverlay.jsx   # In-game HUD
│   │   │
│   │   └── 🚀 platform-web/           # Web Entry Point
│   │       └── main.jsx              # Application entry
│   │
│   ├── 📁 public/                     # Static Assets (add your files here)
│   │   └── assets/
│   │       ├── images/               # PNG, JPG, SVG sprites
│   │       ├── sounds/               # MP3, WAV audio files
│   │       └── fonts/                # TTF, OTF fonts
│   │
│   ├── 📦 dist/                       # ⚠️ AUTO-GENERATED (npm run build)
│   │   ├── index.html
│   │   ├── assets/
│   │   │   ├── index-[hash].js
│   │   │   ├── phaser-[hash].js
│   │   │   └── index-[hash].css
│   │   ├── manifest.webmanifest
│   │   └── sw.js
│   │
│   ├── 🗂️ node_modules/               # ⚠️ AUTO-GENERATED (npm install)
│   ├── 📄 package.json                # Dependencies & scripts
│   ├── 📄 package-lock.json           # Dependency lock file
│   ├── ⚙️ vite.config.js              # Build configuration
│   ├── 📄 index.html                  # HTML template
│   └── 🚫 .gitignore                  # Git ignore rules
│
└── 📱 flutter_android/                 # ═══ ANDROID WRAPPER ═══
    │
    ├── 📂 lib/
    │   └── main.dart                  # ⚠️ DO NOT EDIT (HTTP server + WebView)
    │
    ├── 📂 android/                     # Native Android configuration
    │   ├── app/
    │   │   ├── build.gradle           # Android build config
    │   │   └── src/main/
    │   │       ├── AndroidManifest.xml # Permissions & app settings
    │   │       └── kotlin/com/reactgame/flutter_android/
    │   │           └── MainActivity.kt
    │   ├── gradle.properties           # Gradle settings
    │   └── gradle/                     # Gradle wrapper (auto-managed)
    │
    ├── 📦 assets/web/                  # ⚠️ AUTO-GENERATED (copied from game-web/dist)
    │   ├── index.html
    │   ├── *.js files (flattened)
    │   ├── *.css files (flattened)
    │   └── assets/
    │
    ├── 🏗️ build/                       # ⚠️ AUTO-GENERATED (flutter build)
    │   └── app/outputs/flutter-apk/
    │       └── app-release.apk        # 🚀 YOUR ANDROID APP IS HERE!
    │
    ├── 🗂️ .dart_tool/                  # ⚠️ AUTO-GENERATED (Flutter cache)
    ├── 📄 pubspec.yaml                 # Flutter dependencies
    ├── 📄 pubspec.lock                 # Dependency lock file
    ├── 📄 analysis_options.yaml        # Dart linter config
    └── 🚫 .gitignore                   # Git ignore rules

```

---

## Legend

| Symbol | Meaning | Action |
|--------|---------|--------|
| 🎮 | Development zone | **Work here daily** |
| 📱 | Platform wrapper | **Rarely touch** |
| 🧠 | Game logic | **Edit for gameplay** |
| 🎨 | Rendering | **Edit for visuals** |
| 🖼️ | UI layer | **Edit for menus** |
| 📁 | Asset storage | **Add images/sounds here** |
| 📦 | Build output | **Auto-generated, don't edit** |
| ⚠️ | Warning | **Don't modify manually** |
| 🚀 | Release file | **Deploy this** |
| 🔨 | Build tool | **Run to build** |
| 📝 | Documentation | **Read this** |
| 🚫 | Git ignore | **Not tracked** |
| ⚙️ | Configuration | **Set once, rarely change** |

---

## File Traffic Flow

```
┌─────────────────────────────────────────────────────────────┐
│ DEVELOPMENT PHASE (Daily Work)                              │
│                                                              │
│  You edit files in game-web/src/                            │
│         ↓                                                    │
│  npm run dev                                                 │
│         ↓                                                    │
│  Browser at localhost:5173 (instant hot reload)             │
│                                                              │
│  NO FILE COPYING • NO BUILD STEP • INSTANT FEEDBACK         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ BUILD PHASE (Deployment)                                     │
│                                                              │
│  build-android.bat                                           │
│         ↓                                                    │
│  [1] npm run build in game-web/                             │
│         ↓                                                    │
│  [2] Creates game-web/dist/                                 │
│         ↓                                                    │
│  [3] Clears flutter_android/assets/web/                     │
│         ↓                                                    │
│  [4] Copies dist/ → flutter_android/assets/web/             │
│         ↓                                                    │
│  [5] Flattens JS/CSS files (copies from assets/ to web/)    │
│         ↓                                                    │
│  [6] flutter build apk --release                            │
│         ↓                                                    │
│  [7] Creates APK in flutter_android/build/.../app-release.apk│
│                                                              │
│  ONE COMMAND • FULLY AUTOMATED • 2 MINUTES                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Folder Purposes

### game-web/src/game-core/
**Purpose:** Pure game logic (no rendering)
**Contains:** Game state, player system, enemy logic, collision detection
**Modify when:** Adding gameplay features, changing rules
**Platform:** Runs on web and Android identically

### game-web/src/game-renderer/
**Purpose:** Visual representation using Phaser
**Contains:** Sprites, animations, particle effects, camera
**Modify when:** Changing graphics, adding animations
**Platform:** Phaser renders on both web and Android

### game-web/src/ui/
**Purpose:** React UI components for menus and overlays
**Contains:** Start screen, pause menu, HUD, settings
**Modify when:** Designing menus, adding UI elements
**Platform:** React renders on both web and Android

### game-web/public/assets/
**Purpose:** Static game assets
**Contains:** Images, sounds, fonts, sprite sheets
**Modify when:** Adding new art or audio
**Access in code:** `/assets/images/player.png`

### game-web/dist/
**Purpose:** Compiled web application (production build)
**Contains:** Optimized JS/CSS/HTML bundles
**Generated by:** `npm run build`
**Used for:** Web hosting OR copying to Flutter

### flutter_android/assets/web/
**Purpose:** Web app files for WebView to load
**Contains:** Copy of game-web/dist/ (with flattened structure)
**Generated by:** Build script (automated copy)
**Used by:** HTTP server in main.dart

### flutter_android/build/
**Purpose:** Flutter build artifacts
**Contains:** Compiled APK files, intermediate build files
**Generated by:** `flutter build apk`
**Find APK at:** `build/app/outputs/flutter-apk/app-release.apk`

---

## What NOT to Edit

### ❌ Auto-Generated Folders
- `game-web/dist/` - Rebuilt every time you run `npm run build`
- `game-web/node_modules/` - Managed by npm install
- `flutter_android/assets/web/` - Copied from dist/
- `flutter_android/build/` - Created by Flutter build system
- `flutter_android/.dart_tool/` - Flutter internal cache

### ❌ Infrastructure Files (Unless You Know What You're Doing)
- `flutter_android/lib/main.dart` - HTTP server implementation
- `game-web/vite.config.js` - Build configuration
- `flutter_android/android/gradle/` - Gradle wrapper
- `build-android.bat` - Build automation

### ❌ Lock Files
- `package-lock.json` - Auto-managed by npm
- `pubspec.lock` - Auto-managed by Flutter

---

## Release File Locations

### 🌐 Web Release
**Location:** `game-web/dist/`
**Main file:** `dist/index.html`
**Deploy:** Upload entire `dist/` folder to:
- Netlify
- Vercel  
- GitHub Pages
- Any static file hosting
**Size:** ~2-5 MB

### 📱 Android Release
**Location:** `flutter_android/build/app/outputs/flutter-apk/app-release.apk`
**Deploy options:**
1. Share APK file directly for manual installation
2. Upload to Google Play Console for store distribution
3. Install on device: `flutter install --release`
**Size:** ~40 MB (includes Flutter runtime + Phaser + your game)

---

## Development Cycle Summary

```
┌─────────────────┐
│ 1. DEVELOP      │  Work in game-web/src/
│    (All Day)    │  Test with: npm run dev
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ 2. TEST         │  Play in browser
│    (Minutes)    │  Check gameplay, visuals, UI
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ 3. BUILD        │  Run: build-android.bat
│    (2 minutes)  │  Creates web + Android builds
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ 4. DEPLOY       │  Web: Upload dist/
│    (Minutes)    │  Android: Install/share APK
└─────────────────┘
```

**Time breakdown:**
- Development: 90% of your time
- Testing: 5%
- Building: 5%
- Deploying: Instant (web) or minutes (Play Store submission)

---

## Minimal File Touching

This project is optimized to minimize file movement:

1. **Development:** 
   - Files stay in `game-web/src/`
   - No copying, no building
   - Direct browser access

2. **Build:**
   - One automated script
   - Single copy operation (dist → Flutter)
   - No manual file management

3. **No Duplication:**
   - Root directory cleaned (old duplicate files removed)
   - Single source of truth in `game-web/src/`
   - Generated files clearly marked

**Before cleanup:** Files duplicated in root + game-web/
**After cleanup:** Only game-web/ and flutter_android/ exist
**Reduction:** ~50% fewer files to manage

---

## Quick Reference

| I want to... | File to edit | Location |
|--------------|--------------|----------|
| Change player speed | `PlayerSystem.js` | `game-web/src/game-core/systems/` |
| Add enemy | Create `EnemySystem.js` | `game-web/src/game-core/systems/` |
| Change sprite | `MainScene.js` | `game-web/src/game-renderer/scenes/` |
| Add menu | Create new `.jsx` | `game-web/src/ui/screens/` |
| Add background image | Place file | `game-web/public/assets/images/` |
| Add sound effect | Place file | `game-web/public/assets/sounds/` |
| Test changes | Run `npm run dev` | Terminal in `game-web/` |
| Build Android | Run `build-android.bat` | Root directory |
| Find APK | Look in folder | `flutter_android/build/app/outputs/flutter-apk/` |
| Deploy web | Upload folder | `game-web/dist/` |

---

**Remember:** 
- ✅ Everything you need is in `game-web/src/`
- ✅ One build command creates everything
- ✅ No manual file copying required
- ❌ Never edit `dist/` or `assets/web/` directly
