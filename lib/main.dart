import 'package:computer_clicker/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: ComputerClickerApp(),
    ),
  );
}

class ComputerClickerApp extends ConsumerWidget {
  const ComputerClickerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    
    return MaterialApp(
      title: 'Computer Clicker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: isDarkMode 
          ? const ColorScheme.dark(
              primary: Colors.cyanAccent,
              secondary: Colors.amberAccent,
              surface: Color(0xFF121212),
              background: Colors.black,
            )
          : const ColorScheme.light(
              primary: Colors.cyan,
              secondary: Colors.amber,
              surface: Colors.white,
              background: Color(0xFFF5F5F5),
            ),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const _GameplayScreen(),
          Container(
            color: Colors.blueGrey[900],
            child: const Center(child: Text('Stats screen goes here', style: TextStyle(color: Colors.white))),
          ),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _GameplayScreen extends StatelessWidget {
  const _GameplayScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            
            // Computer Display will go here
            Flexible(
              flex: 5,
              child: Center(
                child: Text('Computer display placeholder', 
                  style: TextStyle(color: Colors.white)),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Upgrades will go here
            Flexible(
              flex: 4,
              child: Center(
                child: Text('Upgrades placeholder', 
                  style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}