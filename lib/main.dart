import 'package:flutter/material.dart';

void main() {
  runApp(const BlindTestApp());
}

class BlindTestApp extends StatelessWidget {
  const BlindTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blindtest Web',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const BlindTestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BlindTestPage extends StatefulWidget {
  const BlindTestPage({super.key});

  @override
  State<BlindTestPage> createState() => _BlindTestPageState();
}

class _BlindTestPageState extends State<BlindTestPage> {
  final int numberOfTeams = 6;

  late List<int> scoresGlobaux;   // scores totaux
  late List<int> scoresQuestion;  // scores de la question en cours
  late List<Color?> tileColors;

  int question = 1;

  @override
  void initState() {
    super.initState();
    _resetAll();
  }

  void _resetAll() {
    scoresGlobaux = List.generate(numberOfTeams, (_) => 0);
    _resetQuestion();
  }

  void _resetQuestion() {
    scoresQuestion = List.generate(numberOfTeams, (_) => 0);
    tileColors = List.generate(numberOfTeams, (_) => null);
  }

  void addPoint(int teamIndex) {
    setState(() {
      if (scoresQuestion[teamIndex] < 2) {
        scoresQuestion[teamIndex]++;
        scoresGlobaux[teamIndex]++;
        _updateColor(teamIndex);
      }
    });
  }

  void removePoint(int teamIndex) {
    setState(() {
      if (scoresQuestion[teamIndex] > 0) {
        scoresQuestion[teamIndex]--;
        scoresGlobaux[teamIndex]--;
        _updateColor(teamIndex);
      }
    });
  }

  void _updateColor(int index) {
    if (scoresQuestion[index] == 0) {
      tileColors[index] = null;
    } else if (scoresQuestion[index] == 1) {
      tileColors[index] = Colors.green[200];
    } else if (scoresQuestion[index] >= 2) {
      tileColors[index] = Colors.amber[300];
    }
  }

  void nextQuestion() {
    setState(() {
      question++;
      _resetQuestion();
    });
  }

  void resetScores() {
    setState(() {
      question = 1;
      _resetAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blindtest - Question $question'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (int i = 0; i < numberOfTeams; i++)
              Card(
                color: tileColors[i],
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text('Équipe ${i + 1}'),
                  subtitle: Text('Score total : ${scoresGlobaux[i]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => addPoint(i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => removePoint(i),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: nextQuestion,
              icon: const Icon(Icons.navigate_next),
              label: const Text('Question suivante'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: resetScores,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Réinitialiser tout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
