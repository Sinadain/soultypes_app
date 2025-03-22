import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/layout.dart';

class SoulLanguagesTestScreen extends StatefulWidget {
  const SoulLanguagesTestScreen({super.key});

  @override
  SoulLanguagesTestScreenState createState() => SoulLanguagesTestScreenState();
}

class SoulLanguagesTestScreenState extends State<SoulLanguagesTestScreen> {
  final List<String> questions = [
    'I feel most appreciated when someone says kind words to me.',
    'I feel loved when someone helps me with tasks.',
    'Receiving thoughtful gifts makes me feel valued.',
    'I enjoy spending quality time with someone who gives me their full attention.',
    'Physical touch is an important way for me to feel connected.',
  ];

  final List<String> options = [
    'Strongly Disagree',
    'Disagree',
    'Neutral',
    'Agree',
    'Strongly Agree',
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
    context.go('/big-five-test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soul Languages Test'),
        centerTitle: true,
      ),
      body: AppLayout.pageContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Progress Indicator
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.deepPurple,
              ),
              minHeight: 8,
            ),
            AppLayout.defaultSpacingVertical(context),
            // Question Counter
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            AppLayout.defaultSpacingVertical(context),
            // Question
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                questions[currentQuestionIndex],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppLayout.defaultSpacingVertical(context),
            AppLayout.defaultSpacingVertical(context),
            // Options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () => _submitResponse(index + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.deepPurple.shade200),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Skip Button
            TextButton(
              onPressed: () => _showResults(),
              child: Text(
                'Skip Test',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
