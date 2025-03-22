import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/config/layout.dart';
import '../../../core/config/navigation.dart';
import '../../providers/firebase_providers.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current user ID from auth state
    final authState = ref.watch(authStateProvider);
    final userId = authState.value?.uid;

    // Watch providers with proper parameters
    final userProfile =
        userId != null
            ? ref.watch(userProfileProvider(userId))
            : const AsyncValue.data(null);
    final discussions = ref.watch(discussionsProvider({}));
    final userConnections =
        userId != null
            ? ref.watch(userConnectionsProvider(userId))
            : const AsyncValue.data(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: AppLayout.pageContainer(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh data
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userProfile.when(
                          data: (profile) => profile?['name'] ?? 'User',
                          loading: () => 'User',
                          error: (_, __) => 'User',
                        ),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // SoulType Card
                _buildSoulTypeCard(context),
                const SizedBox(height: 24),
                // Active Explorations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Explorations',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/explorations'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildExplorationCard(context),
                const SizedBox(height: 24),
                // Recent Connections
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Connections',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/connections'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildConnectionsList(context, userConnections),
                const SizedBox(height: 24),
                // Community Highlights
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Community Highlights',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/discussions'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCommunityHighlights(context, discussions),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppNavigation.bottomNavigationBar(context, 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/explorations/new'),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSoulTypeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luminous Authenticity',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Your SoulType',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'You are driven by a pursuit of truth and express yourself through creativity and deep connections.',
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/profile/soultype'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.explore,
                  color: Colors.deepPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spark Journey: Getting to Know You',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'With Alex • Started 2 days ago',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => context.go('/explorations/1'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stage 2/5 completed',
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                onPressed: () => context.go('/explorations/1'),
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionsList(
    BuildContext context,
    AsyncValue<QuerySnapshot?> connections,
  ) {
    return SizedBox(
      height: 120,
      child: connections.when(
        data: (snapshot) {
          if (snapshot == null || snapshot.docs.isEmpty) {
            return const Center(child: Text('No connections found'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              final connection =
                  snapshot.docs[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap:
                          () => context.go('/profile/${connection['userId']}'),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            connection['photoUrl'] != null
                                ? NetworkImage(connection['photoUrl'])
                                : null,
                        backgroundColor: Colors.grey.shade300,
                        child:
                            connection['photoUrl'] == null
                                ? Text(
                                  connection['name'][0].toUpperCase(),
                                  style: const TextStyle(fontSize: 24),
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      connection['name'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (_, __) => const Center(child: Text('Error loading connections')),
      ),
    );
  }

  Widget _buildCommunityHighlights(
    BuildContext context,
    AsyncValue<QuerySnapshot> discussions,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: discussions.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text('No discussions found'));
          }
          final discussion = snapshot.docs.first.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                discussion['title'] ?? 'Discussion',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${discussion['participantCount'] ?? 0} participants • Active discussion',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed:
                        () => context.go(
                          '/discussions/${snapshot.docs.first.id}',
                        ),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Join Discussion'),
                  ),
                  TextButton.icon(
                    onPressed: () => context.go('/discussions'),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('View All'),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (_, __) => const Center(child: Text('Error loading discussions')),
      ),
    );
  }
}
