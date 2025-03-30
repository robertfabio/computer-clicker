import 'package:computer_clicker/providers/game_provider.dart';
import 'package:computer_clicker/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Provider for dark mode preference 
final isDarkModeProvider = StateProvider<bool>((ref) => true);

// Provider for sound enabled state (changed to default off)
final soundEnabledProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = "";
  bool _isDarkMode = true;
  
  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }
  
  Future<void> _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Theme Settings
            _buildSettingsCategory('Interface Settings'),
            
            // Dark Mode Toggle
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(isDarkModeProvider.notifier).state = value;
                },
                activeColor: Colors.cyanAccent,
              ),
            ),
            
            // Sound toggle
            _buildSettingItem(
              icon: soundEnabled ? Icons.volume_up : Icons.volume_off,
              title: 'Sound Effects',
              trailing: Switch(
                value: soundEnabled,
                onChanged: (value) {
                  ref.read(soundEnabledProvider.notifier).state = value;
                  
                  // Play sound when enabling to provide feedback
                  if (value) {
                    ref.read(soundServiceProvider).playSound(
                      SoundType.click,
                      era: ref.read(computerEraProvider),
                    );
                  }
                },
                activeColor: Colors.cyanAccent,
              ),
            ),
            
            const Divider(color: Colors.cyanAccent, height: 32, thickness: 1),
            
            // Game Data
            _buildSettingsCategory('Game Data'),
            
            // Reset Game
            _buildSettingItem(
              icon: Icons.restart_alt,
              title: 'Reset Progress',
              subtitle: 'Clear all game data and start over',
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.redAccent),
                onPressed: () => _showResetConfirmation(context),
              ),
            ),
            
            const Divider(color: Colors.cyanAccent, height: 32, thickness: 1),
            
            // About
            _buildSettingsCategory('About'),
            
            // App Info
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'Version',
              subtitle: _appVersion,
            ),
            
            // Credits
            _buildSettingItem(
              icon: Icons.code,
              title: 'Made with 💙 using Flutter',
              trailing: IconButton(
                icon: const Icon(Icons.link, size: 18, color: Colors.cyanAccent),
                onPressed: () {
                  // Show credits dialog
                  _showCreditsDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsCategory(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.cyanAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
  
  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: const Text(
            'Reset Progress',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to reset all game progress? This cannot be undone!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.cyanAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Reset'),
              onPressed: () {
                // Play sound effect if enabled
                if (ref.read(soundEnabledProvider)) {
                  ref.read(soundServiceProvider).playSound(
                    SoundType.error,
                    era: ref.read(computerEraProvider),
                  );
                }
                
                // Reset game progress
                ref.read(gameServiceProvider).resetGame();
                
                Navigator.of(context).pop();
                
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Game progress has been reset'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: const Row(
            children: [
              Icon(Icons.rocket_launch, color: Colors.cyanAccent),
              SizedBox(width: 10),
              Text(
                'Credits',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Computer Clicker',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A simple idle clicker game inspired by the evolution of computers.',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              Text(
                'Built with:',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text('• Flutter Framework', style: TextStyle(color: Colors.white70)),
              Text('• Dart Programming Language', style: TextStyle(color: Colors.white70)),
              Text('• Riverpod State Management', style: TextStyle(color: Colors.white70)),
              Text('• AudioPlayers for sound effects', style: TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.cyanAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}