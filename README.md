# Computer Clicker

A Flutter-based incremental clicker game with a computer science theme.

## Getting Started

This project requires Flutter and Dart to be installed on your system.

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run -d windows` (or your preferred platform)

## Sound Assets

The game requires sound assets to be placed in the following directories:

```
assets/audio/sounds/retro/
assets/audio/sounds/classic/
assets/audio/sounds/modern/
assets/audio/sounds/
```

Each era folder should contain:
- click1.mp3, click2.mp3, click3.mp3 - Different click sound variations
- purchase.mp3 - Sound for purchasing upgrades
- error.mp3 - Sound for error events

Common sounds (placed in assets/audio/sounds/):
- achievement.mp3 - Sound for achievements
- level_up.mp3 - Sound for level upgrades

The sound files are currently disabled by default since they are missing in the project. To enable sounds:

1. Add proper MP3 files to the directories listed above
2. Enable sounds in the game settings or change the default value in the code