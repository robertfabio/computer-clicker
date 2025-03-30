import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:computer_clicker/models/computer_era.dart';
import 'package:computer_clicker/providers/game_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sound types available in the game
enum SoundType {
  click,
  purchase,
  error,
  achievement,
  levelUp,
}

// Provider for the sound service
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService(ref);
});

// Provider for sound enabled state
final soundEnabledProvider = StateProvider<bool>((ref) => false);

class SoundService {
  final Ref _ref;
  final AudioCache _audioCache = AudioCache();
  final Map<String, AudioPlayer> _audioPlayers = {};
  final Random _random = Random();
  
  // Track currently playing sounds to avoid overlapping identical sounds
  final Map<SoundType, DateTime> _lastPlayedTime = {};
  
  // Flag to indicate if sound files were successfully loaded
  bool _soundResourcesAvailable = true;
  
  SoundService(this._ref) {
    // Initialize the audio cache
    _initializeAudio();
  }

  void _initializeAudio() async {
    try {
      // Pre-load sound effects
      await _audioCache.loadAll([
        // Click sounds - retro era
        'audio/sounds/retro/click1.mp3',
        'audio/sounds/retro/click2.mp3',
        'audio/sounds/retro/click3.mp3',
        
        // Click sounds - classic era
        'audio/sounds/classic/click1.mp3',
        'audio/sounds/classic/click2.mp3',
        'audio/sounds/classic/click3.mp3',
        
        // Click sounds - modern era
        'audio/sounds/modern/click1.mp3',
        'audio/sounds/modern/click2.mp3',
        'audio/sounds/modern/click3.mp3',
        
        // Purchase sounds
        'audio/sounds/retro/purchase.mp3',
        'audio/sounds/classic/purchase.mp3',
        'audio/sounds/modern/purchase.mp3',
        
        // Error sounds
        'audio/sounds/retro/error.mp3',
        'audio/sounds/classic/error.mp3',
        'audio/sounds/modern/error.mp3',
        
        // Achievement sounds
        'audio/sounds/achievement.mp3',
        
        // Level up sounds
        'audio/sounds/level_up.mp3',
      ]);
    } catch (e) {
      print('Error loading audio resources: $e');
      // Mark sound resources as unavailable
      _soundResourcesAvailable = false;
    }
  }
  
  void playSound(SoundType type, {ComputerEra? era}) async {
    // Check if sound is enabled and resources are available
    final soundEnabled = _ref.read(soundEnabledProvider);
    if (!soundEnabled || !_soundResourcesAvailable) return;
    
    // Get current era if not provided
    final ComputerEra currentEra = era ?? _ref.read(computerEraProvider);
    
    // Get the path for the sound file
    String soundPath;
    
    switch (type) {
      case SoundType.click:
        // Randomly select one of three click sounds for variety
        final clickNum = _random.nextInt(3) + 1;
        final eraFolder = _getEraFolder(currentEra);
        soundPath = 'audio/sounds/$eraFolder/click$clickNum.mp3';
        break;
      case SoundType.purchase:
        final eraFolder = _getEraFolder(currentEra);
        soundPath = 'audio/sounds/$eraFolder/purchase.mp3';
        break;
      case SoundType.error:
        final eraFolder = _getEraFolder(currentEra);
        soundPath = 'audio/sounds/$eraFolder/error.mp3';
        break;
      case SoundType.achievement:
        // Achievement sound is the same for all eras
        soundPath = 'audio/sounds/achievement.mp3';
        break;
      case SoundType.levelUp:
        // Level up sound is the same for all eras
        soundPath = 'audio/sounds/level_up.mp3';
        break;
    }
    
    // Throttle sounds to prevent overlapping identical sounds
    // Don't throttle error sounds or achievement sounds
    if (type != SoundType.error && type != SoundType.achievement) {
      final now = DateTime.now();
      final lastPlayed = _lastPlayedTime[type];
      
      // Only allow the same sound type to play if more than 100ms has passed
      if (lastPlayed != null && 
          now.difference(lastPlayed).inMilliseconds < 100) {
        return;
      }
      
      _lastPlayedTime[type] = now;
    }
    
    // Play the sound
    try {
      final player = AudioPlayer();
      final uniqueKey = '${type.name}_${DateTime.now().millisecondsSinceEpoch}';
      _audioPlayers[uniqueKey] = player;
      
      // Set volume based on sound type
      double volume = _getVolumeForSoundType(type);
      
      // Play the sound
      await player.play(
        AssetSource(soundPath),
        volume: volume,
      );
      
      // Remove the player when done
      player.onPlayerComplete.listen((_) {
        player.dispose();
        _audioPlayers.remove(uniqueKey);
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
  
  String _getEraFolder(ComputerEra era) {
    return era.name.toLowerCase().replaceAll('era', '');
  }
  
  double _getVolumeForSoundType(SoundType type) {
    switch (type) {
      case SoundType.click:
        return 0.2; // Lower volume for frequent click sounds
      case SoundType.purchase:
        return 0.5;
      case SoundType.error:
        return 0.3;
      case SoundType.achievement:
      case SoundType.levelUp:
        return 0.8; // Higher volume for important events
    }
  }
  
  // Dispose of all audio players
  void dispose() {
    for (final player in _audioPlayers.values) {
      player.dispose();
    }
    _audioPlayers.clear();
  }
}