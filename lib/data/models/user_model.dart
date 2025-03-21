import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.phone,
    required super.name,
    super.location,
    super.profilePicUrl,
    super.tagline,
    super.bio,
    super.gender,
    super.pronouns,
    super.birthDate,
    super.birthTime,
    super.birthLocation,
    super.relationshipGoals,
    super.exerciseHabits,
    super.diet,
    super.kids,
    super.pets,
    super.smokingHabits,
    super.drinkingHabits,
    super.educationLevel,
    super.ethnicity,
    super.religion,
    super.politics,
    super.bigFiveScores,
    super.soulLanguages,
    super.valuesScores,
    super.goals,
    super.soulTypeName,
    super.profileComplete,
    super.soultypeDiscovered,
    super.locationSharing,
    super.profileVisibility,
    required super.createdAt,
    required super.lastActive,
  });

  // Create a UserModel from a map (e.g. from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      name: map['name'] ?? '',
      location: map['location'],
      profilePicUrl: map['profilePicUrl'],
      tagline: map['tagline'],
      bio: map['bio'],
      gender: map['gender'],
      pronouns: map['pronouns'],
      birthDate: map['birthDate'],
      birthTime: map['birthTime'],
      birthLocation: map['birthLocation'],
      relationshipGoals: map['relationshipGoals'],
      exerciseHabits: map['exerciseHabits'],
      diet: map['diet'],
      kids: map['kids'],
      pets: map['pets'],
      smokingHabits: map['smokingHabits'],
      drinkingHabits: map['drinkingHabits'],
      educationLevel: map['educationLevel'],
      ethnicity: map['ethnicity'],
      religion: map['religion'],
      politics: map['politics'],
      bigFiveScores:
          map['bigFiveScores'] != null
              ? Map<String, int>.from(map['bigFiveScores'])
              : null,
      soulLanguages:
          map['soulLanguages'] != null
              ? Map<String, int>.from(map['soulLanguages'])
              : null,
      valuesScores:
          map['valuesScores'] != null
              ? Map<String, int>.from(map['valuesScores'])
              : null,
      goals:
          map['goals'] != null
              ? List<Map<String, dynamic>>.from(
                map['goals']?.map((x) => Map<String, dynamic>.from(x)),
              )
              : null,
      soulTypeName: map['soulTypeName'],
      profileComplete: map['profileComplete'] ?? false,
      soultypeDiscovered: map['soultypeDiscovered'] ?? false,
      locationSharing: map['locationSharing'] ?? false,
      profileVisibility: map['profileVisibility'] ?? 'private',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (map['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create a UserModel from a Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data was null');
    }

    return UserModel.fromMap({'id': doc.id, ...data});
  }

  // Convert a UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'name': name,
      'location': location,
      'profilePicUrl': profilePicUrl,
      'tagline': tagline,
      'bio': bio,
      'gender': gender,
      'pronouns': pronouns,
      'birthDate': birthDate,
      'birthTime': birthTime,
      'birthLocation': birthLocation,
      'relationshipGoals': relationshipGoals,
      'exerciseHabits': exerciseHabits,
      'diet': diet,
      'kids': kids,
      'pets': pets,
      'smokingHabits': smokingHabits,
      'drinkingHabits': drinkingHabits,
      'educationLevel': educationLevel,
      'ethnicity': ethnicity,
      'religion': religion,
      'politics': politics,
      'bigFiveScores': bigFiveScores,
      'soulLanguages': soulLanguages,
      'valuesScores': valuesScores,
      'goals': goals,
      'soulTypeName': soulTypeName,
      'profileComplete': profileComplete,
      'soultypeDiscovered': soultypeDiscovered,
      'locationSharing': locationSharing,
      'profileVisibility': profileVisibility,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
    };
  }

  // Create a copy of the UserModel with specified fields updated
  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? location,
    String? profilePicUrl,
    String? tagline,
    String? bio,
    String? gender,
    String? pronouns,
    String? birthDate,
    String? birthTime,
    String? birthLocation,
    String? relationshipGoals,
    String? exerciseHabits,
    String? diet,
    String? kids,
    String? pets,
    String? smokingHabits,
    String? drinkingHabits,
    String? educationLevel,
    String? ethnicity,
    String? religion,
    String? politics,
    Map<String, int>? bigFiveScores,
    Map<String, int>? soulLanguages,
    Map<String, int>? valuesScores,
    List<Map<String, dynamic>>? goals,
    String? soulTypeName,
    bool? profileComplete,
    bool? soultypeDiscovered,
    bool? locationSharing,
    String? profileVisibility,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      location: location ?? this.location,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      tagline: tagline ?? this.tagline,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      pronouns: pronouns ?? this.pronouns,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthLocation: birthLocation ?? this.birthLocation,
      relationshipGoals: relationshipGoals ?? this.relationshipGoals,
      exerciseHabits: exerciseHabits ?? this.exerciseHabits,
      diet: diet ?? this.diet,
      kids: kids ?? this.kids,
      pets: pets ?? this.pets,
      smokingHabits: smokingHabits ?? this.smokingHabits,
      drinkingHabits: drinkingHabits ?? this.drinkingHabits,
      educationLevel: educationLevel ?? this.educationLevel,
      ethnicity: ethnicity ?? this.ethnicity,
      religion: religion ?? this.religion,
      politics: politics ?? this.politics,
      bigFiveScores: bigFiveScores ?? this.bigFiveScores,
      soulLanguages: soulLanguages ?? this.soulLanguages,
      valuesScores: valuesScores ?? this.valuesScores,
      goals: goals ?? this.goals,
      soulTypeName: soulTypeName ?? this.soulTypeName,
      profileComplete: profileComplete ?? this.profileComplete,
      soultypeDiscovered: soultypeDiscovered ?? this.soultypeDiscovered,
      locationSharing: locationSharing ?? this.locationSharing,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
