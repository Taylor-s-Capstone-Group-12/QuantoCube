import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/page/Homeowner/project_page.dart';
import 'package:quantocube/page/homeowner/find_pros.dart';
import 'package:quantocube/tests/test_func.dart';
import 'package:quantocube/utils/project_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quantocube/utils/utils.dart';

class HomeownerHomePage extends StatefulWidget {
  const HomeownerHomePage({super.key});

  @override
  _HomeownerHomePageState createState() => _HomeownerHomePageState();
}

class _HomeownerHomePageState extends State<HomeownerHomePage> {
  late String userId;
  bool isHomeowner = false;
  bool isLoading = true;
  String username = 'user';

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    isHomeowner = await getUserType(userId);
    username = await getNameFromId(userId) ?? 'user';
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              _buildHeader(username),
              const SizedBox(height: 15),
              _buildSearchBar(context),
              const SizedBox(height: 20),
              _buildFindProsButton(context),
              const SizedBox(height: 20),
              _buildOngoingProjects(
                userId,
                isHomeowner,
                5,
              ),
              const SizedBox(height: 20),
              _buildFeaturedContractors(),
              const SizedBox(height: 20),
              // _buildServiceCategories(),
              // const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thursday, 30 May",
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              "Hello, $name.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage("assets/mascot/homeowner.png"),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/geo_search');
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                  context, '/name_search'); // Open the search page
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFindProsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FindProsPage()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/mascot/icons.png", height: 40),
            const SizedBox(width: 10),
            const Text(
              "Find Pros",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingProjects(
      String currentUserId, bool isHomeowner, int fetchLimit) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchOngoingProjects(
        currentUserId: currentUserId,
        isHomeowner: isHomeowner,
        limit: fetchLimit,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text(
            "Error loading projects",
            style: TextStyle(color: Colors.red, fontSize: 16),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            "No ongoing projects",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
        }

        List<Map<String, dynamic>> projects = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ongoing Projects",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        setState(() {}); // Trigger rebuild to refresh data
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, '/project_overview');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...projects.take(3).map(
              (project) {
                return _buildProjectCard(
                  context,
                  project["projectId"],
                  project["name"],
                  project["otherUserName"] ?? "empty",
                  project["status"],
                  project["createdAt"],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectCard(
      BuildContext context,
      String projectId,
      String projectName,
      String otherUserName,
      String status,
      Timestamp createdAt) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/icons/project/$status.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(projectName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(camelToThisCase(status),
                    style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                Text("${formatDate(createdAt)} • $otherUserName",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
            onPressed: () {
              Navigator.pushNamed(context, '/message',
                  arguments: MessagePageArgs(projectId: projectId));
            },
          )
        ],
      ),
    );
  }

  String camelToThisCase(String input) {
    return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirstMapped(RegExp(r'^\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  Widget _buildFeaturedContractors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Featured Contractor",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildContractorCard("assets/mascot/tv_greet.png"),
              const SizedBox(width: 10),
              _buildContractorCard("assets/mascot/tv_smile.png"),
              const SizedBox(width: 10),
              _buildContractorCard("assets/mascot/tv_cone_side.png"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContractorCard(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(imagePath, width: 130, fit: BoxFit.cover),
    );
  }

  Widget _buildServiceCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Service Category",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          children: [
            _buildCategoryCard("Renovations", "assets/mascot/icons.png"),
            _buildCategoryCard("Installations", "assets/mascot/icons.png"),
            _buildCategoryCard("Electrical", "assets/mascot/icons.png"),
            _buildCategoryCard("Plumbing", "assets/mascot/icons.png"),
            _buildCategoryCard("Air Conditioning", "assets/mascot/icons.png"),
            _buildCategoryCard("More", "assets/mascot/icons.png"),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Column(
      children: [
        Image.asset(imagePath, height: 50),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeownerHomePage()),
            (route) => false, // Clears navigation stack
          );
        } else if (index == 1) {
          Navigator.pushNamed(context, '/messages');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/project_overview');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/profile');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}


// /// 🔹 Builds a Single Project Card
  // Widget _buildProjectCard(String projectName, String otherUserName,
  //     String status, Timestamp createdAt) {
  //   return Card(
  //     color: Colors.grey[900],
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: ListTile(
  //       title: Text(
  //         projectName,
  //         style: const TextStyle(
  //             color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       subtitle: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Partner: $otherUserName",
  //             style: const TextStyle(color: Colors.white70, fontSize: 14),
  //           ),
  //           Text(
  //             "Status: $status",
  //             style: const TextStyle(color: Colors.white70, fontSize: 14),
  //           ),
  //           Text(
  //             "Created: ${formatDate(createdAt)}",
  //             style: const TextStyle(color: Colors.white70, fontSize: 14),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildProjectCard(String status, IconData icon, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[900],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           backgroundColor: color,
  //           child: Icon(icon, color: Colors.white),
  //         ),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Project #9876",
  //                 style: TextStyle(color: Colors.grey[400], fontSize: 14),
  //               ),
  //               Text(
  //                 status,
  //                 style: const TextStyle(color: Colors.white, fontSize: 18),
  //               ),
  //               Text(
  //                 "22 Jun - Jackson Hon",
  //                 style: TextStyle(color: Colors.grey[500], fontSize: 14),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
  //       ],
  //     ),
  //   );
  // }

  