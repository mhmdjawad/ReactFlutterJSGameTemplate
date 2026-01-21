# Project Structure & Developer Guide

## 📁 Clean Project Tree

```
reactgame/
│
├── 🎮 game-web/                       # ALL DEVELOPMENT HAPPENS HERE
│   ├── src/
│   │   ├── game-core/                # GAME LOGIC (Platform-agnostic)
│   │   │   ├── GameEngine.js         # Main game loop & coordination
│   │   │   ├── state/                # Game state definitions
│   │   │   │   └── GameState.js      # State structure & initial values
│   │   │   ├── systems/              # Game systems (logic modules)
│   │   │   │   └── PlayerSystem.js   # Player movement, stats, actions
│   │   │   └── save/                 # Save/load functionality
│   │   │       └── SaveManager.js    # IndexedDB persistence
│   │   │
│   │   ├── game-renderer/            # VISUALS (Phaser rendering)
│   │   │   ├── PhaserGame.js         # Phaser wrapper component
│   │   │   └── scenes/
│   │   │       └── MainScene.js      # Game scene (sprites, animations)
│   │   │
│   │   ├── ui/                       # MENUS & UI (React components)
│   │   │   ├── App.jsx               # Root component
│   │   │   ├── App.css               # Global styles
│   │   │   └── screens/
│   │   │       ├── StartScreen.jsx   # Title/menu screen
│   │   │       └── GameOverlay.jsx   # In-game HUD/controls
│   │   │
│   │   └── platform-web/             # Web platform initialization
│   │       └── main.jsx              # Entry point
│   │
│   ├── public/                       # STATIC ASSETS (images, sounds, fonts)
│   │   └── assets/                   # Put your game assets here
│   │       ├── images/               # Sprites, backgrounds
│   │       ├── sounds/               # Audio files
│   │       └── fonts/                # Custom fonts
│   │
│   ├── dist/                         # 📦 BUILD OUTPUT (auto-generated)
│   ├── node_modules/                 # NPM dependencies (auto-generated)
│   ├── package.json                  # Dependencies list
│   ├── vite.config.js               # Build configuration
│   └── index.html                    # HTML template
│
├── 📱 flutter_android/                # ANDROID WRAPPER (rarely touch)
│   ├── lib/
│   │   └── main.dart                 # HTTP server + WebView (DO NOT MODIFY)
│   ├── android/                      # Android native config
│   │   ├── app/
│   │   │   ├── build.gradle         # Android build settings
│   │   │   └── src/main/
│   │   │       ├── AndroidManifest.xml  # Permissions & settings
│   │   │       └── kotlin/.../MainActivity.kt
│   │   └── gradle.properties         # Gradle configuration
│   ├── assets/web/                   # 📦 COPIED WEB BUILD (auto-generated)
│   ├── build/                        # 🚀 APK OUTPUT
│   │   └── app/outputs/flutter-apk/
│   │       └── app-release.apk       # YOUR ANDROID APP IS HERE
│   └── pubspec.yaml                  # Flutter dependencies
│
├── build-android.bat                 # 🔨 ONE-CLICK BUILD SCRIPT
├── .gitignore                        # Git ignore rules
└── README.md                         # Full documentation

```

---

## 🎯 Developer Workflow: What Goes Where

### 1️⃣ Game Logic Changes (No Visuals)

**Location:** `game-web/src/game-core/`

**What to modify:**
- `GameEngine.js` - Game loop, input handling, system coordination
- `state/GameState.js` - Add new state properties (score, health, level)
- `systems/PlayerSystem.js` - Player behavior, movement, abilities

**Example: Add Jump Ability**
```javascript
// game-web/src/game-core/systems/PlayerSystem.js
export class PlayerSystem {
  constructor() {
    this.velocityY = 0;
    this.isGrounded = true;
  }

  jump() {
    if (this.isGrounded) {
      this.velocityY = -500;
      this.isGrounded = false;
    }
  }

  update(dt) {
    // Apply gravity
    this.velocityY += 980 * dt;
    this.y += this.velocityY * dt;
    
    // Check ground collision
    if (this.y >= 500) {
      this.y = 500;
      this.velocityY = 0;
      this.isGrounded = true;
    }
  }
}

// game-web/src/game-core/GameEngine.js
handleInput(input) {
  if (input.space) {
    this.playerSystem.jump();
  }
}
```

---

### 2️⃣ Visual Changes (Sprites, Animations, Effects)

**Location:** `game-web/src/game-renderer/scenes/MainScene.js`

**What to modify:**
- Sprite loading and display
- Animations and effects
- Camera movement
- Particle effects

**Example: Add Player Sprite**
```javascript
// game-web/src/game-renderer/scenes/MainScene.js
export class MainScene extends Phaser.Scene {
  preload() {
    // Load sprite from public/assets/images/
    this.load.image('player', '/assets/images/player.png');
    this.load.spritesheet('player-walk', '/assets/images/player-walk.png', {
      frameWidth: 32,
      frameHeight: 32
    });
  }

  create() {
    // Create sprite
    this.player = this.add.sprite(400, 300, 'player');
    this.player.setScale(2);
    
    // Add animation
    this.anims.create({
      key: 'walk',
      frames: this.anims.generateFrameNumbers('player-walk', { start: 0, end: 7 }),
      frameRate: 10,
      repeat: -1
    });
  }

  update() {
    // Read state from GameEngine
    const state = this.gameEngine.getState();
    this.player.x = state.player.x;
    this.player.y = state.player.y;
    
    // Play animation
    if (state.player.isMoving) {
      this.player.play('walk', true);
    }
  }
}
```

---

### 3️⃣ Menu & UI Changes (Screens, Buttons, HUD)

**Location:** `game-web/src/ui/screens/`

**Files:**
- `StartScreen.jsx` - Title screen, main menu, settings
- `GameOverlay.jsx` - In-game HUD (score, health, buttons)

**Example: Add Pause Menu**
```javascript
// game-web/src/ui/screens/GameOverlay.jsx
import { useState } from 'react';
import './GameOverlay.css';

export function GameOverlay({ gameState, onPause, onResume }) {
  const [isPaused, setIsPaused] = useState(false);

  const handlePause = () => {
    setIsPaused(true);
    onPause();
  };

  const handleResume = () => {
    setIsPaused(false);
    onResume();
  };

  return (
    <div className="game-overlay">
      {/* HUD */}
      <div className="hud">
        <div className="score">Score: {gameState.score}</div>
        <div className="health">Health: {gameState.player.health}</div>
        <button onClick={handlePause}>⏸ Pause</button>
      </div>

      {/* Pause Menu */}
      {isPaused && (
        <div className="pause-menu">
          <h2>Paused</h2>
          <button onClick={handleResume}>Resume</button>
          <button onClick={() => window.location.reload()}>Quit</button>
        </div>
      )}
    </div>
  );
}
```

**Styling:**
```css
/* game-web/src/ui/App.css */
.game-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.hud {
  position: absolute;
  top: 20px;
  left: 20px;
  color: white;
  font-size: 24px;
  pointer-events: auto;
}

.pause-menu {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: rgba(0, 0, 0, 0.9);
  padding: 40px;
  border-radius: 10px;
  pointer-events: auto;
}
```

---

### 4️⃣ Adding Assets (Images, Sounds, Fonts)

**Location:** `game-web/public/assets/`

**Folder structure:**
```
game-web/public/assets/
├── images/
│   ├── player.png
│   ├── enemy.png
│   ├── background.jpg
│   └── spritesheet.png
├── sounds/
│   ├── jump.mp3
│   ├── explosion.wav
│   └── music.mp3
└── fonts/
    └── game-font.ttf
```

**How to use in code:**
```javascript
// In MainScene.js preload()
this.load.image('player', '/assets/images/player.png');
this.load.audio('jump', '/assets/sounds/jump.mp3');
this.load.audio('music', '/assets/sounds/music.mp3');

// In MainScene.js create()
const music = this.sound.add('music', { loop: true });
music.play();

// Play sound effect
this.sound.play('jump');
```

---

### 5️⃣ Game States & Flow

**Location:** `game-web/src/game-core/state/GameState.js`

**Define your game state structure:**
```javascript
export class GameState {
  constructor() {
    // Game flow
    this.currentScreen = 'start'; // 'start', 'playing', 'paused', 'gameover'
    this.level = 1;
    this.score = 0;
    
    // Player state
    this.player = {
      x: 400,
      y: 300,
      health: 100,
      lives: 3,
      powerups: [],
      isMoving: false,
      direction: 'right'
    };
    
    // Enemies
    this.enemies = [];
    
    // World state
    this.time = 0;
    this.isPaused = false;
  }
}
```

**State flow in App.jsx:**
```javascript
// game-web/src/ui/App.jsx
function App() {
  const [screen, setScreen] = useState('start');
  const [gameState, setGameState] = useState(null);

  const startGame = () => {
    const engine = new GameEngine();
    setGameState(engine.getState());
    setScreen('playing');
  };

  return (
    <>
      {screen === 'start' && <StartScreen onStart={startGame} />}
      {screen === 'playing' && (
        <>
          <PhaserGame gameEngine={engine} />
          <GameOverlay 
            gameState={gameState} 
            onPause={() => setScreen('paused')}
          />
        </>
      )}
      {screen === 'gameover' && <GameOverScreen score={gameState.score} />}
    </>
  );
}
```

---

## 🔨 Build Process (Automated)

### Development (Daily Work)
```bash
cd game-web
npm run dev
```
- Opens http://localhost:5173
- Hot reload enabled
- Changes appear instantly
- Test in browser

### Build for Android (When Ready)
```bash
# Windows: Just double-click
build-android.bat

# Or manually:
cd game-web
npm run build               # Builds to game-web/dist/
cd ..
# Build script handles the rest automatically
```

**What the build script does:**
1. Clears `flutter_android/assets/web/`
2. Copies `game-web/dist/*` to `flutter_android/assets/web/`
3. Flattens JS/CSS files (copies from assets/ to web/)
4. Runs `flutter build apk --release`
5. APK is saved to `flutter_android/build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 Build Outputs & Release Files

### Web Build (For Hosting)
**Location:** `game-web/dist/`

After running `npm run build`, you get:
```
game-web/dist/
├── index.html           # Main HTML
├── assets/
│   ├── index-[hash].js  # Your game code
│   ├── phaser-[hash].js # Phaser library
│   └── index-[hash].css # Styles
├── manifest.webmanifest # PWA manifest
└── sw.js                # Service worker
```

**How to deploy web:**
1. Upload entire `dist/` folder to web hosting
2. Works with: Netlify, Vercel, GitHub Pages, any static host
3. URL: https://yoursite.com

### Android Build (APK)
**Location:** `flutter_android/build/app/outputs/flutter-apk/app-release.apk`

**This is your Android app!**
- Install on device: `flutter install --release`
- Share APK file for manual installation
- Upload to Google Play Store

**APK size:** ~40MB (includes Flutter + Phaser + Your game)

---

## 🚫 Files You Should NEVER Modify

### Auto-Generated (Will be overwritten)
❌ `game-web/dist/*` - Cleared and rebuilt every build
❌ `game-web/node_modules/*` - Managed by npm
❌ `flutter_android/assets/web/*` - Copied from dist/
❌ `flutter_android/build/*` - Build artifacts
❌ `flutter_android/.dart_tool/*` - Flutter cache

### Infrastructure (Copy from template)
❌ `flutter_android/lib/main.dart` - HTTP server code
❌ `flutter_android/android/gradle/` - Gradle wrapper
❌ `game-web/vite.config.js` - Build config (unless you know what you're doing)

---

## ⚡ Quick Reference

| Task | Location | File |
|------|----------|------|
| Add player ability | `game-web/src/game-core/systems/` | `PlayerSystem.js` |
| Change visuals | `game-web/src/game-renderer/scenes/` | `MainScene.js` |
| Add menu screen | `game-web/src/ui/screens/` | Create new `.jsx` |
| Add sprite image | `game-web/public/assets/images/` | Any image file |
| Add sound effect | `game-web/public/assets/sounds/` | `.mp3` or `.wav` |
| Change game state | `game-web/src/game-core/state/` | `GameState.js` |
| Modify HUD | `game-web/src/ui/screens/` | `GameOverlay.jsx` |
| Build for web | Run: `npm run build` | Output: `game-web/dist/` |
| Build for Android | Run: `build-android.bat` | Output: `flutter_android/build/.../app-release.apk` |

---

## 🎨 Complete Example: Adding a New Enemy

### Step 1: Logic (game-core)
```javascript
// game-web/src/game-core/systems/EnemySystem.js
export class EnemySystem {
  constructor() {
    this.enemies = [];
  }

  spawn(x, y, type) {
    this.enemies.push({
      id: Date.now(),
      x, y,
      type,
      health: 100,
      speed: 100
    });
  }

  update(dt) {
    this.enemies.forEach(enemy => {
      enemy.x += enemy.speed * dt;
    });
  }
}

// Add to GameEngine.js
import { EnemySystem } from './systems/EnemySystem.js';

constructor() {
  this.enemySystem = new EnemySystem();
}
```

### Step 2: Visuals (game-renderer)
```javascript
// game-web/src/game-renderer/scenes/MainScene.js
preload() {
  this.load.image('enemy', '/assets/images/enemy.png');
}

create() {
  this.enemySprites = this.add.group();
}

update() {
  const enemies = this.gameEngine.enemySystem.enemies;
  
  // Update sprites
  enemies.forEach(enemy => {
    let sprite = this.enemySprites.getChildren()
      .find(s => s.enemyId === enemy.id);
    
    if (!sprite) {
      sprite = this.add.sprite(enemy.x, enemy.y, 'enemy');
      sprite.enemyId = enemy.id;
      this.enemySprites.add(sprite);
    }
    
    sprite.x = enemy.x;
    sprite.y = enemy.y;
  });
}
```

### Step 3: Asset
Place `enemy.png` in `game-web/public/assets/images/enemy.png`

### Step 4: Test
```bash
cd game-web
npm run dev
```

### Step 5: Build Android
```bash
build-android.bat
```

Done! Enemy appears in both web and Android versions.

---

## 📝 File Traffic Minimization

**Current setup minimizes file movement:**

1. **Development:** All work in `game-web/src/` - no copying needed
2. **Build:** Single command copies dist to Flutter once
3. **No redundancy:** Root directory cleaned, only one copy of code
4. **Efficient:** Vite bundles everything, Flutter serves via HTTP

**File flow:**
```
[Development]
game-web/src/ → Edit files → npm run dev → Browser (instant)

[Production]
game-web/src/ → npm run build → game-web/dist/ → 
Copy to flutter_android/assets/web/ → flutter build apk → APK file
```

**Total copies:** 1 (dist to Flutter assets)
**No duplicate code:** Root cleaned, everything in game-web/

---

Remember:
- ✅ Develop in `game-web/`
- ✅ Test with `npm run dev`
- ✅ Build with `build-android.bat`
- ✅ Find APK in `flutter_android/build/app/outputs/flutter-apk/`
- ❌ Never edit `dist/` or `assets/web/` directly
