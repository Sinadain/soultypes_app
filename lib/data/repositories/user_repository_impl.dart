import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Future<UserEntity?> getUserById(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();
      if (!docSnapshot.exists) return null;
      return UserModel.fromDocument(docSnapshot);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Stream<UserEntity?> getUserStream(String userId) {
    return _usersCollection
        .doc(userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.exists ? UserModel.fromDocument(snapshot) : null,
        );
  }

  @override
  Future<void> createUser(UserEntity user) async {
    try {
      final userModel = user as UserModel;
      await _usersCollection.doc(user.id).set(userModel.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      final userModel = user as UserModel;
      await _usersCollection.doc(user.id).update(userModel.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<List<UserEntity>> searchUsersByName(String query) async {
    try {
      final querySnapshot =
          await _usersCollection
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThanOrEqualTo: '$query\uf8ff')
              .limit(20)
              .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<List<UserEntity>> getCompatibleUsers(
    String userId, {
    int limit = 10,
  }) async {
    try {
      // Get the current user first to access their personality traits
      final currentUser = await getUserById(userId);
      if (currentUser == null) {
        throw Exception('Current user not found');
      }

      // This is a simplified implementation
      // In a real app, you would implement a more sophisticated algorithm
      // to find compatible users based on personality traits
      final querySnapshot =
          await _usersCollection
              .where('id', isNotEqualTo: userId)
              .limit(limit)
              .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get compatible users: $e');
    }
  }

  @override
  Future<void> updateUserPersonalityResults(
    String userId, {
    Map<String, int>? bigFiveScores,
    Map<String, int>? soulLanguages,
    Map<String, int>? valuesScores,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (bigFiveScores != null) {
        updates['bigFiveScores'] = bigFiveScores;
      }

      if (soulLanguages != null) {
        updates['soulLanguages'] = soulLanguages;
      }

      if (valuesScores != null) {
        updates['valuesScores'] = valuesScores;
      }

      if (updates.isNotEmpty) {
        await _usersCollection.doc(userId).update(updates);
      }
    } catch (e) {
      throw Exception('Failed to update personality results: $e');
    }
  }

  @override
  Future<void> updateUserGoals(
    String userId,
    List<Map<String, dynamic>> goals,
  ) async {
    try {
      await _usersCollection.doc(userId).update({'goals': goals});
    } catch (e) {
      throw Exception('Failed to update user goals: $e');
    }
  }
}
