import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/layout.dart';

class BirthDetailsScreen extends StatefulWidget {
  const BirthDetailsScreen({super.key});

  @override
  BirthDetailsScreenState createState() => BirthDetailsScreenState();
}

class BirthDetailsScreenState extends State<BirthDetailsScreen> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();
  final TextEditingController _birthLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Birth Details')),
      body: AppLayout.pageContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _birthDateController,
              decoration: const InputDecoration(
                labelText: 'Birth Date (YYYY-MM-DD)',
              ),
              keyboardType: TextInputType.datetime,
            ),
            AppLayout.defaultSpacingVertical(context),
            TextField(
              controller: _birthTimeController,
              decoration: const InputDecoration(
                labelText: 'Birth Time (HH:mm)',
              ),
              keyboardType: TextInputType.datetime,
            ),
            AppLayout.defaultSpacingVertical(context),
            TextField(
              controller: _birthLocationController,
              decoration: const InputDecoration(labelText: 'Birth Location'),
            ),
            AppLayout.defaultSpacingVertical(context),
            ElevatedButton(
              onPressed: () => context.go('/values'),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
