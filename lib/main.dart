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

import 'services/auto_status_service.dart';

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

// =========================================================
// AUTH GATE
// =========================================================

class AuthGate extends StatelessWidget {
const AuthGate({super.key});

@override
Widget build(BuildContext context) {
return StreamBuilder<User?>(
stream: FirebaseAuth.instance.authStateChanges(),
builder: (context, authSnapshot) {
// =================================================
// ĐANG KIỂM TRA AUTH
// =================================================


    if (authSnapshot.connectionState ==
        ConnectionState.waiting) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = authSnapshot.data;

    // =================================================
    // CHƯA ĐĂNG NHẬP
    // =================================================

    if (user == null) {
      return const LoginScreen();
    }

    // =================================================
    // LẮNG NGHE USER FIRESTORE
    // =================================================

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        // =================================================
        // ĐANG TẢI USER
        // =================================================

        if (userSnapshot.connectionState ==
            ConnectionState.waiting) {
          return Scaffold(
            backgroundColor:
                AppColors.softMint,
            body: const Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        // =================================================
        // KHÔNG CÓ DATA
        // =================================================

        if (!userSnapshot.hasData) {
          return Scaffold(
            backgroundColor:
                AppColors.softMint,
            body: const Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        // =================================================
        // CHƯA CÓ USER DOCUMENT
        // =================================================

        if (!userSnapshot.data!.exists) {
          return const CompleteProfileScreen();
        }

        final data =
            userSnapshot.data!.data()
                as Map<String, dynamic>;

        final String? role =
            data["role"];

        final String? status =
            data["status"];

        final bool profileCompleted =
            data["profileCompleted"] ??
                false;

        // =================================================
        // CHƯA HOÀN THÀNH PROFILE
        // =================================================

        if (!profileCompleted ||
            role == null) {
          return const CompleteProfileScreen();
        }

        // =================================================
        // ĐANG CHỜ DUYỆT
        // =================================================

        if (status == "pending") {
          return const WaitingApprovalScreen();
        }

        // =================================================
        // BỊ TỪ CHỐI
        // =================================================

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

        // =================================================
        // ĐÃ ĐƯỢC DUYỆT
        // =================================================

        if (status == "approved") {
          return AppStatusInitializer(
            role: role,
          );
        }

        // =================================================
        // DỮ LIỆU KHÔNG HỢP LỆ
        // =================================================

        return const Scaffold(
          body: Center(
            child: Text(
              "Invalid account data",
            ),
          ),
        );
      },
    );
  },
);


}
}

// =========================================================
// APP STATUS INITIALIZER
// =========================================================
//
// Chạy AutoStatusService một lần khi user đã đăng nhập
// và account đã được approved.
//
// Không gọi trực tiếp trong build() của AuthGate.
// Điều này tránh việc build lại gây gọi Firestore nhiều lần.
//
// =========================================================

class AppStatusInitializer
extends StatefulWidget {
final String role;

const AppStatusInitializer({
super.key,
required this.role,
});

@override
State<AppStatusInitializer> createState() =>
_AppStatusInitializerState();
}

class _AppStatusInitializerState
extends State<AppStatusInitializer> {
late Future<void> _initializeFuture;

@override
void initState() {
super.initState();


_initializeFuture =
    _initializeAppStatus();


}

Future<void> _initializeAppStatus() async {
try {
await AutoStatusService()
.updateAllStatuses();
} catch (e) {
debugPrint(
"Auto status update error: $e",
);


  // Không chặn người dùng vào app
  // nếu quá trình update status bị lỗi.
}


}

@override
Widget build(BuildContext context) {
return FutureBuilder<void>(
future: _initializeFuture,
builder: (
context,
snapshot,
) {
// =================================================
// ĐANG ĐỒNG BỘ STATUS
// =================================================
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return Scaffold(
        backgroundColor:
            AppColors.softMint,
        body: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    // =================================================
    // SAU KHI ĐỒNG BỘ XONG
    // =================================================

    switch (widget.role) {
      case "mentor":
        return const MentorScreen();

      case "mentee":
        return const MenteeScreen();

      case "admin":
        return const AdminScreen();

      default:
        return const Scaffold(
          body: Center(
            child: Text(
              "Invalid account role",
            ),
          ),
        );
    }
  },
);


}
}
