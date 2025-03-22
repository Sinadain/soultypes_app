import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/layout.dart';

class ValuesScreen extends StatefulWidget {
  const ValuesScreen({super.key});

  @override
  ValuesScreenState createState() => ValuesScreenState();
}

class ValuesScreenState extends State<ValuesScreen> {
  final List<String> values = [
    'Authenticity',
    'Compassion',
    'Creativity',
    'Growth',
    'Integrity',
    'Kindness',
    'Resilience',
    'Wisdom',
  ];

  final List<String> selectedValues = [];

  void _toggleValue(String value) {
    setState(() {
      if (selectedValues.contains(value)) {
        selectedValues.remove(value);
      } else if (selectedValues.length < 5) {
        selectedValues.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Values'), centerTitle: true),
      body: AppLayout.pageContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Header
            Text(
              'What matters most to you?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select up to 5 values that resonate with your core beliefs',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            AppLayout.defaultSpacingVertical(context),
            // Selection Counter
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${selectedValues.length}/5 values selected',
                style: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppLayout.defaultSpacingVertical(context),
            // Values Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: values.length,
                itemBuilder: (context, index) {
                  final value = values[index];
                  final isSelected = selectedValues.contains(value);
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color:
                            isSelected
                                ? Colors.deepPurple
                                : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _toggleValue(value),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getValueIcon(value),
                              size: 32,
                              color:
                                  isSelected
                                      ? Colors.deepPurple
                                      : Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Colors.deepPurple
                                        : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Next Button
            ElevatedButton(
              onPressed:
                  selectedValues.isNotEmpty ? () => context.go('/goals') : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue with ${selectedValues.length} values',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _getValueIcon(String value) {
    switch (value) {
      case 'Authenticity':
        return Icons.verified_user;
      case 'Compassion':
        return Icons.favorite;
      case 'Creativity':
        return Icons.palette;
      case 'Growth':
        return Icons.trending_up;
      case 'Integrity':
        return Icons.gavel;
      case 'Kindness':
        return Icons.emoji_emotions;
      case 'Resilience':
        return Icons.fitness_center;
      case 'Wisdom':
        return Icons.lightbulb;
      default:
        return Icons.star;
    }
  }
}
