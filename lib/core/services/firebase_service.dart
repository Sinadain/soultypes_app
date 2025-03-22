import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User Profile Management
  Stream<Map<String, dynamic>?> getUserProfile(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String name,
    String? photoUrl,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? soulTypeData,
  }) async {
    final Map<String, dynamic> userData = {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'preferences': preferences ?? {},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Create user document
    await _firestore.collection('users').doc(userId).set(userData);

    // If soulTypeData is provided, save it
    if (soulTypeData != null) {
      await saveSoulTypeData(userId: userId, soulTypeData: soulTypeData);
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? photoUrl,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? additionalData,
  }) async {
    final Map<String, dynamic> data = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (name != null) data['name'] = name;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (preferences != null) data['preferences'] = preferences;
    if (additionalData != null) data.addAll(additionalData);

    await _firestore.collection('users').doc(userId).update(data);
  }

  // SoulType Data
  Future<void> saveSoulTypeData({
    required String userId,
    required Map<String, dynamic> soulTypeData,
  }) async {
    final Map<String, dynamic> data = {
      ...soulTypeData,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('soulType')
        .doc('data')
        .set(data);

    // Update user document with soulType summary
    await _firestore.collection('users').doc(userId).update({
      'soulType': soulTypeData['type'],
      'soulTypeUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getSoulTypeData(String userId) async {
    final doc =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('soulType')
            .doc('data')
            .get();
    return doc.data();
  }

  // Community Features
  Future<void> createDiscussion({
    required String title,
    required String content,
    required String userId,
    required String userName,
    List<String>? tags,
    String? category,
    String? imageUrl,
  }) async {
    await _firestore.collection('discussions').add({
      'title': title,
      'content': content,
      'userId': userId,
      'userName': userName,
      'tags': tags ?? [],
      'category': category,
      'imageUrl': imageUrl,
      'likes': 0,
      'comments': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getDiscussions({
    String? category,
    List<String>? tags,
    int? limit,
    String? userId,
  }) {
    Query query = _firestore.collection('discussions');

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    if (tags != null && tags.isNotEmpty) {
      query = query.where('tags', arrayContainsAny: tags);
    }

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    query = query.orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  Future<void> addDiscussionComment({
    required String discussionId,
    required String userId,
    required String userName,
    required String content,
    String? parentCommentId,
  }) async {
    final batch = _firestore.batch();

    // Add comment
    final commentRef =
        _firestore
            .collection('discussions')
            .doc(discussionId)
            .collection('comments')
            .doc();

    batch.set(commentRef, {
      'userId': userId,
      'userName': userName,
      'content': content,
      'parentCommentId': parentCommentId,
      'likes': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update discussion comment count
    final discussionRef = _firestore
        .collection('discussions')
        .doc(discussionId);
    batch.update(discussionRef, {
      'comments': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> likeDiscussion(String discussionId, String userId) async {
    final batch = _firestore.batch();
    final discussionRef = _firestore
        .collection('discussions')
        .doc(discussionId);
    final likeRef = _firestore
        .collection('discussions')
        .doc(discussionId)
        .collection('likes')
        .doc(userId);

    // Check if already liked
    final likeDoc = await likeRef.get();
    if (likeDoc.exists) {
      // Unlike
      batch.delete(likeRef);
      batch.update(discussionRef, {
        'likes': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Like
      batch.set(likeRef, {
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      batch.update(discussionRef, {
        'likes': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  // Exploration Journey
  Future<String> createExploration({
    required String userId,
    required String title,
    required String description,
    required List<String> participants,
    required Map<String, dynamic> stages,
    String? imageUrl,
  }) async {
    final docRef = await _firestore.collection('explorations').add({
      'userId': userId,
      'title': title,
      'description': description,
      'participants': participants,
      'stages': stages,
      'imageUrl': imageUrl,
      'currentStage': 0,
      'totalStages': stages.length,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> updateExplorationProgress({
    required String explorationId,
    required int currentStage,
    required int totalStages,
    Map<String, dynamic>? stageData,
    List<String>? completedParticipants,
  }) async {
    final Map<String, dynamic> data = {
      'currentStage': currentStage,
      'totalStages': totalStages,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (stageData != null) {
      data['stageData'] = stageData;
    }

    if (completedParticipants != null) {
      data['completedParticipants'] = completedParticipants;
    }

    if (currentStage >= totalStages) {
      data['status'] = 'completed';
      data['completedAt'] = FieldValue.serverTimestamp();
    }

    await _firestore.collection('explorations').doc(explorationId).update(data);
  }

  // File Storage
  Future<String> uploadProfilePhoto(String userId, String filePath) async {
    final ref = _storage.ref().child('profile_photos/$userId');
    await ref.putData(filePath as dynamic);
    return await ref.getDownloadURL();
  }

  Future<String> uploadDiscussionImage(
    String discussionId,
    String filePath,
  ) async {
    final ref = _storage.ref().child('discussion_images/$discussionId');
    await ref.putData(filePath as dynamic);
    return await ref.getDownloadURL();
  }

  Future<String> uploadExplorationImage(
    String explorationId,
    String filePath,
  ) async {
    final ref = _storage.ref().child('exploration_images/$explorationId');
    await ref.putData(filePath as dynamic);
    return await ref.getDownloadURL();
  }

  // User Connections
  Future<void> createConnection({
    required String userId,
    required String connectedUserId,
    required String connectionType,
    String? message,
  }) async {
    final batch = _firestore.batch();

    // Create connection document
    final connectionRef = _firestore.collection('connections').doc();
    batch.set(connectionRef, {
      'userId': userId,
      'connectedUserId': connectedUserId,
      'connectionType': connectionType,
      'message': message,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Create reverse connection for the connected user
    final reverseConnectionRef = _firestore.collection('connections').doc();
    batch.set(reverseConnectionRef, {
      'userId': connectedUserId,
      'connectedUserId': userId,
      'connectionType': connectionType,
      'message': message,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> updateConnectionStatus({
    required String connectionId,
    required String status,
    String? message,
  }) async {
    final Map<String, dynamic> data = {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (message != null) {
      data['message'] = message;
    }

    if (status == 'accepted') {
      data['acceptedAt'] = FieldValue.serverTimestamp();
    }

    await _firestore.collection('connections').doc(connectionId).update(data);
  }

  Stream<QuerySnapshot> getUserConnections(String userId) {
    return _firestore
        .collection('connections')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // SoulType Matching
  Future<List<Map<String, dynamic>>> findMatchingSoulTypes({
    required String userId,
    required Map<String, dynamic> preferences,
    int? limit,
  }) async {
    // Get user's SoulType data
    final userSoulType = await getSoulTypeData(userId);
    if (userSoulType == null) return [];

    // Query for matching SoulTypes based on preferences
    Query query = _firestore.collection('users');

    // Add filters based on preferences
    if (preferences['ageRange'] != null) {
      query = query
          .where('age', isGreaterThanOrEqualTo: preferences['ageRange'][0])
          .where('age', isLessThanOrEqualTo: preferences['ageRange'][1]);
    }

    if (preferences['location'] != null) {
      query = query.where('location', isEqualTo: preferences['location']);
    }

    if (preferences['interests'] != null) {
      query = query.where(
        'interests',
        arrayContainsAny: preferences['interests'],
      );
    }

    if (preferences['soulType'] != null) {
      query = query.where('soulType', isEqualTo: preferences['soulType']);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .where((doc) => doc.id != userId)
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
