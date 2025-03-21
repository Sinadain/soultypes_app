class UserEntity {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? location;

  // Profile
  final String? profilePicUrl;
  final String? tagline;
  final String? bio;
  final String? gender;
  final String? pronouns;
  final String? birthDate; // Format: YYYY-MM-DD
  final String? birthTime; // Format: HH:mm (24-hour)
  final String? birthLocation;
  final String? relationshipGoals;
  final String? exerciseHabits;
  final String? diet;
  final String? kids;
  final String? pets;
  final String? smokingHabits;
  final String? drinkingHabits;
  final String? educationLevel;
  final String? ethnicity;
  final String? religion;
  final String? politics;

  // Personality
  final Map<String, int>?
  bigFiveScores; // e.g., {'Openness': 85, 'Conscientiousness': 60, ...}
  final Map<String, int>?
  soulLanguages; // e.g., {'affirming_words': 70, 'supportive_actions': 30, ...}
  final Map<String, int>?
  valuesScores; // e.g., {'altruism': 90, 'growth': 80, ...}
  final List<Map<String, dynamic>>?
  goals; // List of goals, each with categoryId, text, isCustom

  // App-specific
  final String? soulTypeName;
  final bool profileComplete;
  final bool soultypeDiscovered;
  final bool locationSharing;
  final String profileVisibility; // public, connections, private
  final DateTime createdAt;
  final DateTime lastActive;

  const UserEntity({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.location,
    this.profilePicUrl,
    this.tagline,
    this.bio,
    this.gender,
    this.pronouns,
    this.birthDate,
    this.birthTime,
    this.birthLocation,
    this.relationshipGoals,
    this.exerciseHabits,
    this.diet,
    this.kids,
    this.pets,
    this.smokingHabits,
    this.drinkingHabits,
    this.educationLevel,
    this.ethnicity,
    this.religion,
    this.politics,
    this.bigFiveScores,
    this.soulLanguages,
    this.valuesScores,
    this.goals,
    this.soulTypeName,
    this.profileComplete = false,
    this.soultypeDiscovered = false,
    this.locationSharing = false,
    this.profileVisibility = 'private',
    required this.createdAt,
    required this.lastActive,
  });
}
