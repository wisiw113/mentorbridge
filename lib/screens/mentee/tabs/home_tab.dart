// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint,

      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        title: const Text(
          "Mentor Connect",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=5",
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //================ WELCOME ====================

            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 17,
                color: AppColors.gray,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Find Your Perfect Mentor",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 22),

            //================ HERO ====================

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Learn Faster\nGrow Better",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Connect with experienced mentors\nand accelerate your career.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 22),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.mintGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Find Mentor",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            //================ SEARCH ====================

            TextField(
              decoration: InputDecoration(
                hintText: "Search mentor...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Platform Statistics",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 18),

            //================ STATS ====================

            Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      children: [

                        Icon(
                          Icons.people_alt,
                          color: AppColors.mintGreen,
                          size: 40,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "250+",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Mentors",
                          style: TextStyle(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      children: [

                        Icon(
                          Icons.school,
                          color: AppColors.mintGreen,
                          size: 40,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "1,000+",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Students",
                          style: TextStyle(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      children: [

                        Icon(
                          Icons.category,
                          color: AppColors.warning,
                          size: 40,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "25",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Categories",
                          style: TextStyle(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      children: [

                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 40,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Rating",
                          style: TextStyle(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),
                        //================ CATEGORIES ====================

            const Text(
              "Popular Categories",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                Chip(
                  avatar: Icon(Icons.code, color: AppColors.mintGreen),
                  label: Text("Programming"),
                ),
                Chip(
                  avatar: Icon(Icons.phone_android,
                      color: AppColors.mintGreen),
                  label: Text("Mobile"),
                ),
                Chip(
                  avatar: Icon(Icons.computer,
                      color: AppColors.mintGreen),
                  label: Text("Web"),
                ),
                Chip(
                  avatar: Icon(Icons.palette,
                      color: AppColors.mintGreen),
                  label: Text("UI/UX"),
                ),
                Chip(
                  avatar: Icon(Icons.smart_toy,
                      color: AppColors.mintGreen),
                  label: Text("AI"),
                ),
                Chip(
                  avatar: Icon(Icons.bar_chart,
                      color: AppColors.mintGreen),
                  label: Text("Business"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            //================ FEATURED MENTOR ====================

            const Text(
              "Featured Mentor",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 38,
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=12"),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "Emily Wilson",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Senior Flutter Developer",
                          style: TextStyle(
                            color: AppColors.gray,
                          ),
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [

                            Icon(Icons.star,
                                color: Colors.amber, size: 18),

                            SizedBox(width: 4),

                            Text("4.9"),

                            SizedBox(width: 15),

                            Icon(Icons.schedule,
                                size: 18,
                                color: AppColors.gray),

                            SizedBox(width: 4),

                            Text("150 Sessions"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //================ TOP MENTORS ====================

            const Text(
              "Top Mentors",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),

            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {

                final names = [
                  "Sarah Johnson",
                  "David Lee",
                  "Michael Brown"
                ];

                final jobs = [
                  "UI/UX Designer",
                  "Backend Engineer",
                  "AI Engineer"
                ];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=${20 + index}",
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              names[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              jobs[index],
                              style: const TextStyle(
                                color: AppColors.gray,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Row(
                              children: [

                                Icon(Icons.star,
                                    color: Colors.amber,
                                    size: 18),

                                SizedBox(width: 4),

                                Text("4.9"),
                              ],
                            )
                          ],
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.mintGreen,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text("View"),
                      )
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            //================ REVIEW ====================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.deepGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [

                  Icon(
                    Icons.format_quote,
                    color: Colors.white,
                    size: 45,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Mentor Connect helped thousands of students improve their skills and achieve career success.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(Icons.star,
                          color: Colors.amber),

                      Icon(Icons.star,
                          color: Colors.amber),

                      Icon(Icons.star,
                          color: Colors.amber),

                      Icon(Icons.star,
                          color: Colors.amber),

                      Icon(Icons.star,
                          color: Colors.amber),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Start Learning Today",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}