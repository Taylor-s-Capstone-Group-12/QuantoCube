import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/subcategory_page.dart';
import 'package:quantocube/page/Homeowner/homeowner_homepage.dart';
import 'package:quantocube/page/Homeowner/project_page.dart';


class FindProsPage extends StatefulWidget {
  const FindProsPage({super.key});

  @override
  State<FindProsPage> createState() => _FindProsPageState();
}

class _FindProsPageState extends State<FindProsPage> {
  String? selectedCategory;

  final List<Map<String, String>> categories = [
    {"title": "All", "image": "assets/categories/all.png"},
    {
      "title": "Interior Painting",
      "image": "assets/categories/interior_painting.png"
    },
    {
      "title": "Exterior Painting",
      "image": "assets/categories/exterior_painting.png"
    },
    {
      "title": "Flooring Installation",
      "image": "assets/categories/flooring_installation.png"
    },
    {
      "title": "Interior Design",
      "image": "assets/categories/interior_design.png"
    },
    {
      "title": "Cabinetry and Carpentry",
      "image": "assets/categories/cabinetry.png"
    },
  ];

  @override
  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.orange,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex, // Ensures the correct tab is highlighted
    onTap: (index) {
      if (index == 0 && currentIndex != 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeownerHomePage()),
          (route) => false, // Clears navigation stack
        );
      } else if (index == 1 && currentIndex != 1) {
        Navigator.pushNamed(context, '/messages');
      } else if (index == 2 && currentIndex != 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FindProsPage()),
        );
      } else if (index == 3 && currentIndex != 3) {
        Navigator.pushNamed(context, '/profile');
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''), // Find Pros
      BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
    ],
  );
}

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Find Pros",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // ✅ Filter Button + Selected Category Badge
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  onPressed: _showCategoryFilterDialog,
                ),
                if (selectedCategory != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedCategory!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = null;
                            });
                          },
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ✅ Categories Grid
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(), // Prevents UI freeze
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(
                    categories[index]["title"]!,
                    categories[index]["image"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(context, 2), // 2 = FindProsPage

    );
  }

  // ✅ Category Card (Fixed Navigation)
  Widget _buildCategoryCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        // ✅ Avoid multiple navigations
        if (selectedCategory != title) {
          setState(() {
            selectedCategory = title;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubcategoryPage(categoryTitle: title),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.image, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Filter Dialog (Now Fully Functional)
  void _showCategoryFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: categories.map((category) {
            return ListTile(
              title: Text(category["title"]!,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  selectedCategory = category["title"];
                });
                Navigator.pop(context);

                // ✅ Navigate to the selected category immediately
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubcategoryPage(categoryTitle: category["title"]!),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
