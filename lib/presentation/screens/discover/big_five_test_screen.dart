import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/layout.dart';

class BigFiveTestScreen extends StatefulWidget {
  const BigFiveTestScreen({super.key});

  @override
  BigFiveTestScreenState createState() => BigFiveTestScreenState();
}

class BigFiveTestScreenState extends State<BigFiveTestScreen> {
  final List<String> questions = [
    'I see myself as someone who is reserved.',
    'I see myself as someone who is generally trusting.',
    'I see myself as someone who tends to be lazy.',
    'I see myself as someone who is relaxed, handles stress well.',
    'I see myself as someone who has few artistic interests.',
  ];

  final Map<int, int> responses = {};
  int currentQuestionIndex = 0;

  void _submitResponse(int response) {
    setState(() {
      responses[currentQuestionIndex] = response;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    // Placeholder for results calculation
    context.go('/birth-details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Big Five Test')),
      body: AppLayout.pageContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[currentQuestionIndex],
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppLayout.defaultSpacingVertical(context),
            for (int i = 1; i <= 5; i++)
              Padding(
                padding: EdgeInsets.only(bottom: AppLayout.defaultPadding),
                child: ElevatedButton(
                  onPressed: () => _submitResponse(i),
                  child: Text('Option $i'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
