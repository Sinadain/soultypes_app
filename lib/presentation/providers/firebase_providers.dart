import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/firebase_service.dart';

// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// User Profile Provider
final userProfileProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, userId) {
      final firebaseService = ref.watch(firebaseServiceProvider);
      return firebaseService.getUserProfile(userId);
    });

// SoulType Data Provider
final soulTypeDataProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
      final firebaseService = ref.watch(firebaseServiceProvider);
      return firebaseService.getSoulTypeData(userId);
    });

// Discussions Provider
final discussionsProvider =
    StreamProvider.family<QuerySnapshot, Map<String, dynamic>>((ref, filters) {
      final firebaseService = ref.watch(firebaseServiceProvider);
      return firebaseService.getDiscussions(
        category: filters['category'] as String?,
        tags: filters['tags'] as List<String>?,
        limit: filters['limit'] as int?,
      );
    });

// User Connections Provider
final userConnectionsProvider = StreamProvider.family<QuerySnapshot, String>((
  ref,
  userId,
) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getUserConnections(userId);
});

// Matching SoulTypes Provider
final matchingSoulTypesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final firebaseService = ref.watch(firebaseServiceProvider);
      return firebaseService.findMatchingSoulTypes(
        userId: params['userId'] as String,
        preferences: params['preferences'] as Map<String, dynamic>,
        limit: params['limit'] as int?,
      );
    });
