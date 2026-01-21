# Cross-Platform Game Template (React + Phaser + Flutter Android)

## 🎮 Quick Summary

**One codebase → Web + Android**

Write your game once in JavaScript, deploy everywhere:
- 🌐 **Web:** Vite dev server with hot reload
- 📱 **Android:** Flutter APK wrapper with embedded HTTP server

**Key Innovation:** Embedded HTTP server in Flutter bypasses WebView file:// restrictions.

**For detailed project structure and developer workflow:** See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

---

## 📁 Project Structure

```
reactgame/
├── game-web/              # 🎮 ALL DEVELOPMENT HERE
│   ├── src/
│   │   ├── game-core/    # Game logic (pure JavaScript)
│   │   ├── game-renderer/# Visuals (Phaser)
│   │   ├── ui/           # Menus (React)
│   │   └── platform-web/ # Entry point
│   ├── public/assets/    # Images, sounds, fonts
│   └── dist/             # 📦 Web build output
│
├── flutter_android/       # 📱 Android wrapper
│   ├── lib/main.dart     # HTTP server + WebView
│   ├── assets/web/       # 📦 Copied from dist/
│   └── build/app/outputs/flutter-apk/
│       └── app-release.apk  # 🚀 YOUR ANDROID APP
│
└── build-android.bat      # One-click build script
```

**Complete file tree:** [FILE_TREE.md](FILE_TREE.md) - Visual diagram with all files and folders
**Developer workflow:** [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Examples and detailed guide

---

## 🚀 Quick Start

### Web Development
```bash
cd game-web
npm install
npm run dev
```
Open http://localhost:5173

### Android Build
```bash
# One command builds everything
build-android.bat

# Or step by step:
cd game-web
npm run build
# (Script handles copying and flutter build automatically)
```

**Output:** `flutter_android/build/app/outputs/flutter-apk/app-release.apk`

---

## 🎯 Where to Make Changes

| What You Want | Where to Edit | Details |
|---------------|---------------|---------|
| **Game logic** | `game-web/src/game-core/` | Player movement, enemies, collisions |
| **Visuals** | `game-web/src/game-renderer/scenes/` | Sprites, animations, effects |
| **Menus/UI** | `game-web/src/ui/screens/` | Title screen, HUD, pause menu |
| **Assets** | `game-web/public/assets/` | Images, sounds, fonts |
| **Game state** | `game-web/src/game-core/state/` | Score, health, level data |

**Full examples and code samples:** [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

---

## ⚙️ Technical Configuration

### Critical Settings (Already Configured)

1. **Flutter HTTP Server** (flutter_android/lib/main.dart)
   - Embedded HTTP server serving assets from Flutter asset bundle
   - Binds to localhost:8080-8089
   - Serves with proper Content-Type headers
   - WebView loads from `http://127.0.0.1:8080/index.html`

2. **Android Permissions** (flutter_android/android/app/src/main/AndroidManifest.xml)
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <application android:usesCleartextTraffic="true">
   ```

3. **Flat Asset Structure** (flutter_android/assets/web/)
   - All JS/CSS files must be in the same directory as index.html
   - No nested `assets/assets/` structure
   - HTML uses relative paths: `src="index-BGIh5gHK.js"` not `src="/assets/index-BGIh5gHK.js"`

4. **WebView Settings** (flutter_android/lib/main.dart)
   ```dart
   - JavaScriptMode.unrestricted
   - MixedContentMode.alwaysAllow
   - Load from HTTP server, not file://
   ```

5. **Gradle/Java Versions** (flutter_android/android/)
   - Gradle 8.8
   - Kotlin 2.1.0
   - AGP 8.6.0
   - Java 17 (configure via `flutter config --jdk-dir`)

6. **Vite Configuration** (game-web/vite.config.js)
   - Code splitting disabled for simpler asset management
   - PWA plugin for offline capability

**Don't modify these unless you know what you're doing.**

---

## 🐛 Troubleshooting

### Issue: Black screen in APK
**Solution:** Check flutter logs for ERR_FAILED errors. Ensure:
- HTTP server started successfully
- Assets are flattened (JS/CSS in web/ root)
- Internet permission in AndroidManifest.xml
- usesCleartextTraffic="true"

### Issue: ERR_FILE_NOT_FOUND
**Solution:** Assets are in wrong location. Run:
```bash
cd flutter_android/assets/web
copy assets\*.js .
copy assets\*.css .
```

### Issue: Gradle build fails
**Solution:** Configure Java 17:
```bash
flutter config --jdk-dir="C:\Program Files\Java\jdk-17"
flutter doctor -v
```

### Issue: Assets don't update in APK
**Solution:** Rebuild web assets first:
```bash
cd game-web
npm run build
# Then copy to Flutter and rebuild APK
```

### Issue: Game works in web but not Android
**Solution:** Check for browser-specific APIs:
- localStorage/IndexedDB work in both
- Avoid window.location changes
- Use touch events, not just mouse
- Test in Chrome DevTools mobile view

**For more issues:** Check flutter logs with `flutter logs`

---

## 📚 Documentation

- **[README.md](README.md)** - This file (quick start & reference)
- **[FILE_TREE.md](FILE_TREE.md)** - Visual file structure with flow diagrams
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Complete developer guide with examples

---

## 🎯 Development vs Build Process

### 👨‍💻 Development Phase (Daily Work)

**What:** Code, test, iterate
**Where:** `game-web/` directory only
**Tools:** Text editor + browser
**Command:** `npm run dev`
**Output:** Localhost web server
**Speed:** Instant (hot reload)

### 🔨 Build Phase (Deployment)

**What:** Package for distribution
**Where:** Automated script handles everything
**Tools:** Build script
**Command:** `build-android.bat`
**Output:** Web files + Android APK
**Speed:** ~2 minutes

**File Flow:**
```
Development: You edit → Browser shows (instant)
Build: You run script → APK created (2 min)
```

**No manual file copying needed** - build script automates everything.

---

## 🎮 Complete Example Workflow

**Goal:** Add a jump ability

1. **Logic** (5 min)
   - Edit `game-web/src/game-core/systems/PlayerSystem.js`
   - Add `jump()` method
   - Test with `npm run dev`

2. **Visual** (3 min)
   - Edit `game-web/src/game-renderer/scenes/MainScene.js`
   - Add jump animation
   - Test in browser

3. **Deploy** (2 min)
   - Run `build-android.bat`
   - Install APK on device

**Total:** 10 minutes from idea to Android app!

---

## 📦 Release Locations

### Web Release
**File:** `game-web/dist/index.html` (+ assets folder)
**Deploy:** Upload to any static host (Netlify, Vercel, GitHub Pages)
**Size:** ~2-5MB

### Android Release
**File:** `flutter_android/build/app/outputs/flutter-apk/app-release.apk`
**Deploy:** Share APK or upload to Google Play Store
**Size:** ~40MB

---

## 🚀 Performance & Optimization

### Web Build
- Code splitting disabled for simplicity
- Can enable if APK size is concern
- Phaser already optimized for mobile

### Android APK
- Release builds use R8 minification
- Tree-shaking reduces bundle size
- Enable ProGuard for additional optimization
- Current APK size: ~40MB

### Runtime
- Phaser runs at 60 FPS
- HTTP server has minimal overhead (~1ms)
- Save system uses IndexedDB (fast)
- No network requests after initial load

---

## 🎓 Learning Path

**New to the project?**
1. Read [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) (10 min)
2. Run `npm run dev` and test the demo
3. Edit `PlayerSystem.js` to change player speed
4. See your change in browser instantly
5. Build Android with `build-android.bat`

**Ready to build your game?**
1. Design game state in `GameState.js`
2. Implement logic in `game-core/systems/`
3. Add visuals in `game-renderer/scenes/`
4. Create menus in `ui/screens/`
5. Add assets to `public/assets/`

---

## 🤝 Contributing & Team Setup

**Adding team members:**
1. Clone repository
2. Install: Node.js, Flutter SDK, Java 17, Android SDK
3. Run `flutter doctor` to verify setup
4. Run `npm install` in game-web/
5. Read [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

**Development workflow:**
- Everyone works in `game-web/src/`
- Test locally with `npm run dev`
- Commit changes to git
- One person builds APK when ready

---

## 📄 License

MIT License - Modify and use as needed

**Key Technologies:**
- React 18.2.0 - UI framework
- Phaser 3.70.0 - Game engine
- Vite 7.3.1 - Build tool
- Flutter 3.38.7 - Android wrapper
- webview_flutter 4.4.0 - WebView
- shelf 1.4.0 - HTTP server

---

## ✨ What Makes This Template Special

1. **Single Codebase:** Write once, deploy web + Android
2. **Fast Development:** Instant hot reload in browser
3. **Clean Architecture:** Game logic separated from rendering
4. **Simple Deployment:** One-click build script
5. **No Bloat:** Cleaned project, only essential files
6. **Bypass Restrictions:** HTTP server solves WebView asset loading
7. **Well Documented:** Complete guides and examples

---

## 🎯 Next Steps

**Enhance the template:**
- [ ] Add iOS wrapper
- [ ] Add analytics
- [ ] Add cloud saves
- [ ] Add multiplayer

**Build your game:**
- [ ] Design game mechanics
- [ ] Create sprites and assets
- [ ] Implement gameplay
- [ ] Add menus and UI
- [ ] Test and polish
- [ ] Deploy!

---

**Questions?** Check [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed examples and workflows.

