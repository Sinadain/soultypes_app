import '../entities/user_entity.dart';

abstract class UserRepository {
  // Get a user by their ID
  Future<UserEntity?> getUserById(String userId);

  // Get a stream of user data that updates in real-time
  Stream<UserEntity?> getUserStream(String userId);

  // Create a new user
  Future<void> createUser(UserEntity user);

  // Update user information
  Future<void> updateUser(UserEntity user);

  // Delete a user
  Future<void> deleteUser(String userId);

  // Search for users by name
  Future<List<UserEntity>> searchUsersByName(String query);

  // Get users with matching personality traits
  Future<List<UserEntity>> getCompatibleUsers(String userId, {int limit = 10});

  // Update user's personality test results
  Future<void> updateUserPersonalityResults(
    String userId, {
    Map<String, int>? bigFiveScores,
    Map<String, int>? soulLanguages,
    Map<String, int>? valuesScores,
  });

  // Update user's goals
  Future<void> updateUserGoals(String userId, List<Map<String, dynamic>> goals);
}
