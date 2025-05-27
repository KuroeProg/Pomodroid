import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Racine de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodroid',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

// Page principale avec le timer et l'historique
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int workDuration = 25 * 60; // 25 minutes en secondes

  int remainingTime = workDuration;
  bool isRunning = false;
  late final Ticker _ticker;
  final List<int> history = [];

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (!isRunning) return;
    setState(() {
      remainingTime = workDuration - elapsed.inSeconds;
      if (remainingTime <= 0) {
        isRunning = false;
        history.add(workDuration);
        _ticker.stop();
        remainingTime = workDuration;
      }
    });
  }

  void _startTimer() {
    if (!isRunning) {
      isRunning = true;
      _ticker.start();
    }
  }

  void _stopTimer() {
    isRunning = false;
    _ticker.stop();
    setState(() {});
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodroid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _formatTime(remainingTime),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            isRunning
                ? ElevatedButton(
                    onPressed: _stopTimer,
                    child: const Text('Arrêter'),
                  )
                : ElevatedButton(
                    onPressed: _startTimer,
                    child: const Text('Démarrer'),
                  ),
            const SizedBox(height: 40),
            const Text(
              'Historique des sessions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final session = history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('Session ${index + 1}'),
                    subtitle: Text('Durée : ${_formatTime(session)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
