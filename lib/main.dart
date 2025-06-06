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

  late List<int> scoresGlobaux;
  late List<int> scoresQuestion;
  late List<Color?> tileColors;
  late List<TextEditingController> teamNameControllers;

  int question = 1;

  @override
  void initState() {
    super.initState();
    teamNameControllers = List.generate(
      numberOfTeams,
      (i) => TextEditingController(text: 'Équipe ${i + 1}'),
    );
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

  void _updateColor(int index) {
    switch (scoresQuestion[index]) {
      case 0:
        tileColors[index] = null;
        break;
      case 1:
        tileColors[index] = Colors.green[200];
        break;
      case 2:
        tileColors[index] = Colors.amber[300];
        break;
      case 3:
        tileColors[index] = Colors.purple[300];
        break;
    }
  }

  void addPoint(int index) {
    setState(() {
      if (scoresQuestion[index] < 3) {
        scoresQuestion[index]++;
        scoresGlobaux[index]++;
        _updateColor(index);
      }
    });
  }

  void removePoint(int index) {
    setState(() {
      if (scoresQuestion[index] > 0) {
        scoresQuestion[index]--;
        scoresGlobaux[index]--;
        _updateColor(index);
      }
    });
  }

  void resetTeamRound(int index) {
    setState(() {
      scoresGlobaux[index] -= scoresQuestion[index];
      scoresQuestion[index] = 0;
      _updateColor(index);
    });
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
  void dispose() {
    for (final controller in teamNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blindtest - Question $question'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: numberOfTeams,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => addPoint(i),
                  child: Card(
                    color: tileColors[i],
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: teamNameControllers[i],
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                                Text(
                                  'Total : ${scoresGlobaux[i]} | Manche : ${scoresQuestion[i]}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => removePoint(i),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.cancel, color: Colors.grey),
                            onPressed: () => resetTeamRound(i),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
