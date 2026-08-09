import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../services/google_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleAuthService googleAuth = GoogleAuthService();

  bool loadingGoogle = false;

  Future<void> loginWithGoogle() async {
    setState(() => loadingGoogle = true);

    try {
      final user = await googleAuth.signInWithGoogle();

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đã hủy đăng nhập"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi: $e"),
        ),
      );
    }

    if (mounted) {
      setState(() => loadingGoogle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: Colors.transparent,
  body: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      gradient: AppColors.backgroundGradient,
    ),
    child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
            children: [

              /// ================= IMAGE =================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    "assets/images/login.jpg",
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "MentorBridge",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Learn • Connect • Grow",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  "Kết nối Mentor và Mentee để chia sẻ kiến thức",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// ================= GOOGLE BUTTON =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed:
                        loadingGoogle ? null : loginWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shadowColor:
                          Colors.green.withOpacity(.45),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    child: loadingGoogle
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                          8),
                                ),
                                child: Image.asset(
                                  "assets/images/google-logo.webp",
                                  width: 22,
                                ),
                              ),

                              const SizedBox(width: 15),

                              const Text(
                                "Đăng nhập bằng Google",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 28),
                child: Divider(),
              ),

              const SizedBox(height: 25),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [

                    _feature(
                      Icons.people_alt_rounded,
                      "Kết nối Mentor chất lượng",
                    ),

                    const SizedBox(height: 18),

                    _feature(
                      Icons.chat_bubble_outline_rounded,
                      "Chat trực tiếp mọi lúc",
                    ),

                    const SizedBox(height: 18),

                    _feature(
                      Icons.calendar_month_rounded,
                      "Đặt lịch mentoring dễ dàng",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "Bằng cách tiếp tục, bạn đồng ý với",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "Điều khoản sử dụng & Chính sách bảo mật",
                ),
              ),

              Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  );
}

  static Widget _feature(
      IconData icon,
      String title,
      ) {
    return Row(
      children: [

        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: Colors.green,
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}