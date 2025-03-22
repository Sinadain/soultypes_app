import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/layout.dart';

class DiscoverSoultypeScreen extends StatelessWidget {
  const DiscoverSoultypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Your SoulType'),
        centerTitle: true,
      ),
      body: AppLayout.pageContainer(
        context: context,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Welcome Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 64,
                  color: Colors.deepPurple,
                ),
              ),
              AppLayout.defaultSpacingVertical(context),
              // Welcome Text
              Text(
                'Welcome to the SoulType Discovery Process!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              AppLayout.defaultSpacingVertical(context),
              // Description
              Text(
                'This process will guide you through a series of assessments to help you understand your personality and discover your unique SoulType.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              AppLayout.defaultSpacingVertical(context),
              AppLayout.defaultSpacingVertical(context),
              // Soul Languages Test Card
              _buildTestCard(
                context,
                title: 'Soul Languages Test',
                description:
                    'Discover how you express and receive love in relationships',
                icon: Icons.favorite,
                onTap: () => context.go('/soul-languages-test'),
              ),
              AppLayout.defaultSpacingVertical(context),
              // Big Five Test Card
              _buildTestCard(
                context,
                title: 'Big Five Test',
                description:
                    'Understand your core personality traits and characteristics',
                icon: Icons.psychology,
                onTap: () => context.go('/big-five-test'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.deepPurple, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
