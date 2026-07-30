import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/CompleteProfileScreen.dart';
import 'screens/auth/waitingApprovalScreen.dart';

import 'screens/mentor/screens/mentor_screen.dart';
import 'screens/mentee/screens/mentee_screen.dart';
import 'screens/admin/admin_screen.dart';

import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.softMint,
        primaryColor: AppColors.mintGreen,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Đang kiểm tra đăng nhập
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = authSnapshot.data;

        // Chưa đăng nhập
        if (user == null) {
          return const LoginScreen();
        }

        // Lắng nghe Firestore realtime
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            // Đang tải dữ liệu
            if (!userSnapshot.hasData) {
              return Scaffold(
                backgroundColor: AppColors.softMint,
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Chưa có document
            if (!userSnapshot.data!.exists) {
              return const CompleteProfileScreen();
            }

            final data =
                userSnapshot.data!.data() as Map<String, dynamic>;

            final String? role = data["role"];
            final String? status = data["status"];
            final bool profileCompleted =
                data["profileCompleted"] ?? false;

            // Chưa hoàn thành hồ sơ
            if (!profileCompleted || role == null) {
              return const CompleteProfileScreen();
            }

            // Chờ duyệt
            if (status == "pending") {
              return const WaitingApprovalScreen();
            }

            // Bị từ chối
            if (status == "rejected") {
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Account Rejected",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            }

            // Đã duyệt
            if (status == "approved") {
              switch (role) {
                case "mentor":
                  return const MentorScreen();

                case "mentee":
                  return const MenteeScreen();

                case "admin":
                  return const AdminScreen();
              }
            }

            // Dữ liệu không hợp lệ
            return const Scaffold(
              body: Center(
                child: Text("Invalid account data"),
              ),
            );
          },
        );
      },
    );
  }
}