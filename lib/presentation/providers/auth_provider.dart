import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/firebase_service.dart';

// FirebaseAuth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Authentication state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Sign-in method
final signInProvider = Provider<SignInService>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return SignInService(firebaseService);
});

// Google Sign-In method
final googleSignInProvider = Provider<GoogleSignInService>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return GoogleSignInService(firebaseService);
});

class SignInService {
  final FirebaseService _firebaseService;

  SignInService(this._firebaseService);

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Create or update user profile with default preferences
        await _firebaseService.createUserProfile(
          userId: userCredential.user!.uid,
          email: email,
          name: email.split('@')[0], // Default name from email
          preferences: {
            'notifications': true,
            'privacy': 'public',
            'theme': 'light',
            'language': 'en',
          },
        );
      }

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Create user profile with default preferences
        await _firebaseService.createUserProfile(
          userId: userCredential.user!.uid,
          email: email,
          name: email.split('@')[0], // Default name from email
          preferences: {
            'notifications': true,
            'privacy': 'public',
            'theme': 'light',
            'language': 'en',
          },
        );
      }

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    await _firebaseService.updateUserProfile(
      userId: userId,
      preferences: preferences,
    );
  }
}

class GoogleSignInService {
  final FirebaseService _firebaseService;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInService(this._firebaseService);

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        // Create or update user profile with default preferences
        await _firebaseService.createUserProfile(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name:
              userCredential.user!.displayName ??
              userCredential.user!.email!.split('@')[0],
          photoUrl: userCredential.user!.photoURL,
          preferences: {
            'notifications': true,
            'privacy': 'public',
            'theme': 'light',
            'language': 'en',
          },
        );
      }

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    await _firebaseService.updateUserProfile(
      userId: userId,
      preferences: preferences,
    );
  }
}
