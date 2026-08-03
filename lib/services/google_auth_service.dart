
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  Future<void> _initializeGoogleSignIn() async {
    if (_googleInitialized) {
      return;
    }

    await _googleSignIn.initialize();

    _googleInitialized = true;
  }

  Future<User?> signInWithGoogle() async {
    try {
      print("🔵 STEP 1 - Start Google Sign In");

      late UserCredential userCredential;

      // =========================================================
      // WEB
      // =========================================================

      if (kIsWeb) {
        print("🌐 WEB - Using signInWithPopup");

        final provider = GoogleAuthProvider();

        provider.setCustomParameters({
          'prompt': 'select_account',
        });

        userCredential =
            await _auth.signInWithPopup(provider);
      }

      // =========================================================
      // ANDROID / OTHER NATIVE PLATFORMS
      // =========================================================

      else {
        print("📱 ANDROID - Using Google Sign-In");

        await _initializeGoogleSignIn();

        final GoogleSignInAccount googleUser =
            await _googleSignIn.authenticate();

        print(
          "🟢 Google account: ${googleUser.email}",
        );

        final GoogleSignInAuthentication googleAuth =
            googleUser.authentication;

        final String? idToken =
            googleAuth.idToken;

        if (idToken == null) {
          throw Exception(
            'Không lấy được Google ID Token.',
          );
        }

        final credential =
            GoogleAuthProvider.credential(
          idToken: idToken,
        );

        userCredential =
            await _auth.signInWithCredential(
          credential,
        );
      }

      // =========================================================
      // FIREBASE USER
      // =========================================================

      final User? user =
          userCredential.user;

      if (user == null) {
        print("❌ User is null");
        return null;
      }

      print(
        "🟢 STEP 2 - User UID: ${user.uid}",
      );

      // =========================================================
      // FIRESTORE USER DOCUMENT
      // =========================================================

      final userRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid);

      final doc =
          await userRef.get();

      if (!doc.exists) {
        print("🆕 Creating new user");

        await userRef.set({
          "email": user.email,
          "displayName": user.displayName,
          "photoURL": user.photoURL,

          // Chưa chọn role
          "role": null,

          // Chưa gửi yêu cầu duyệt
          "status": null,

          "profileCompleted": false,
          "createdAt":
              FieldValue.serverTimestamp(),
        });
      } else {
        print(
          "ℹ️ User already exists",
        );
      }

      return user;
    }

    on FirebaseAuthException catch (e) {
      print(
        "🔥 FirebaseAuthException",
      );
      print("Code: ${e.code}");
      print("Message: ${e.message}");

      return null;
    }

    catch (e) {
      print("🔥 ERROR: $e");

      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        print(
          "⚠️ Google Sign-Out Error: $e",
        );
      }
    }
  }
}

