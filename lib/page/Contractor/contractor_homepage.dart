import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractorHomePage extends StatelessWidget {
  final String userName; // Dynamically fetched from login data

  const ContractorHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              formattedDate,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(), // Navigation Drawer
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Hello, $userName!",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search something here..",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Schedule Section
            _sectionTitle("1 Schedule Plan Today", "0 completed"),
            _scheduleCard(),
            const SizedBox(height: 20),
            // To-Do Section
            _sectionTitle("To Do", ""),
            _todoItem("Review New Requests", "3 new requests", Icons.build),
            _todoItem("Review Negotiate Requests", "1 new request", Icons.assignment),
            const SizedBox(height: 20),
            // Inspiration Section
            _sectionTitle("Inspiration", ""),
            _inspirationGrid(),
          ],
        ),
      ),
    );
  }

  // 🔹 Navigation Drawer
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/profile.jpg"), // Profile image
                ),
                const SizedBox(height: 10),
                const Text(
                  "Jackson Hon",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text("View Profile", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Menu Items
          Expanded(
            child: ListView(
              children: [
                _drawerItem(Icons.home, "Home"),
                _drawerItem(Icons.work, "Projects"),
                _drawerItem(Icons.calendar_today, "Calendar"),
                _drawerItem(Icons.message, "Message", badgeCount: 9),
                _drawerItem(Icons.notifications, "Notifications"),
                _drawerItem(Icons.shopping_cart, "QuantoMall"),
                _drawerItem(Icons.group, "Community"),
                _drawerItem(Icons.bar_chart, "Analytics"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Drawer Item
  Widget _drawerItem(IconData icon, String title, {int badgeCount = 0}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: badgeCount > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$badgeCount",
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      onTap: () {
        // Add navigation logic here
      },
    );
  }

  // 🔹 Section Title
  Widget _sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 🔹 Schedule Card
  Widget _scheduleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Matiny Org", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("10:30 AM - 09:30", style: TextStyle(color: Colors.white, fontSize: 14)),
          Text("Appointment with Matiny Org", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  // 🔹 To-Do List Item
  Widget _todoItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Inspiration Grid
  Widget _inspirationGrid() {
    List<Map<String, String>> inspirations = [
      {"title": "Modern Luxury Dining Concept", "author": "Mike Zayn", "image": "assets/ContractorHomepage/Asset1.png"},
      {"title": "Minimal Aesthetic Interior", "author": "Jackson Lin", "image": "assets/ContractorHomepage/Asset2.png"},
      {"title": "Modern Woody Taste Sofa", "author": "Mike Zayn", "image": "assets/ContractorHomepage/Asset3.png"},
      {"title": "Modern Woody Space", "author": "Mike Zayn", "image": "assets/ContractorHomepage/Asset4.png"},
      {"title": "Luxury Living Concept", "author": "Mike Zayn", "image": "assets/ContractorHomepage/Asset5.png"},
      {"title": "Luxury Living Concept 2", "author": "Mike Zayn", "image": "assets/ContractorHomepage/Asset6.png"},
    ];

    Widget inspirationCard(String imagePath, String title, String author) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                author,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: inspirations.length,
      itemBuilder: (context, index) {
        return inspirationCard(
          inspirations[index]["image"]!,
          inspirations[index]["title"]!,
          inspirations[index]["author"]!,
        );
      },
    );
  }
}
