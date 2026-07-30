import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      print("🔵 STEP 1 - Start Google Sign In");

      final provider = GoogleAuthProvider();

      provider.setCustomParameters({
        'prompt': 'select_account',
      });

      final UserCredential userCredential =
          await _auth.signInWithPopup(provider);

      final User? user = userCredential.user;

      if (user == null) {
        print("❌ User is null");
        return null;
      }

      print("🟢 STEP 2 - User UID: ${user.uid}");

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final doc = await userRef.get();

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
          "createdAt": FieldValue.serverTimestamp(),
        });
      } else {
        print("ℹ️ User already exists");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("🔥 FirebaseAuthException");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      return null;
    } catch (e) {
      print("🔥 ERROR: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}