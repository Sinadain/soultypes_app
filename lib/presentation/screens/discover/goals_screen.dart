import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/layout.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  GoalsScreenState createState() => GoalsScreenState();
}

class GoalsScreenState extends State<GoalsScreen> {
  final List<String> categories = [
    'Personal',
    'Career',
    'Relationships',
    'Health',
    'Financial',
    'Spiritual',
    'Creative',
    'Community',
  ];

  final Map<String, List<String>> goals = {
    'Personal': ['Improve self-confidence', 'Learn a new skill'],
    'Career': ['Get a promotion', 'Start a business'],
    'Relationships': ['Build stronger friendships', 'Find a life partner'],
    'Health': ['Exercise regularly', 'Eat healthier'],
    'Financial': ['Save for a house', 'Pay off debt'],
    'Spiritual': ['Meditate daily', 'Explore spirituality'],
    'Creative': ['Write a book', 'Learn an instrument'],
    'Community': ['Volunteer locally', 'Organize a community event'],
  };

  String? selectedCategory;
  final List<String> selectedGoals = [];

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Your Goals'), centerTitle: true),
      body: AppLayout.pageContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Header
            Text(
              'What do you want to achieve?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select your goals to help us understand your aspirations',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            AppLayout.defaultSpacingVertical(context),
            // Category Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text('Select a category'),
                  isExpanded: true,
                  items:
                      categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
            AppLayout.defaultSpacingVertical(context),
            // Goals List
            if (selectedCategory != null)
              Expanded(
                child: ListView.builder(
                  itemCount: goals[selectedCategory]!.length,
                  itemBuilder: (context, index) {
                    final goal = goals[selectedCategory]![index];
                    final isSelected = selectedGoals.contains(goal);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? Colors.deepPurple
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _toggleGoal(goal),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.deepPurple.shade50
                                          : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color:
                                      isSelected
                                          ? Colors.deepPurple
                                          : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  goal,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color:
                                        isSelected
                                            ? Colors.deepPurple
                                            : Colors.black87,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            AppLayout.defaultSpacingVertical(context),
            // Finish Button
            ElevatedButton(
              onPressed:
                  selectedGoals.isNotEmpty
                      ? () => context.go('/dashboard')
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue with ${selectedGoals.length} goals',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
