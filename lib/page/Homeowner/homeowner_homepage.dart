import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/find_pros.dart';

class HomeownerHomePage extends StatelessWidget {
  const HomeownerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // Space for status bar
              _buildHeader(), // User greeting
              const SizedBox(height: 15),
              _buildSearchBar(), // Location + Search
              const SizedBox(height: 20),
              _buildFindProsButton(context), // Find Pros button
              const SizedBox(height: 20),
              _buildOngoingProjects(), // Ongoing projects section
              const SizedBox(height: 20),
              _buildFeaturedContractors(), // Featured contractors section
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(), // Persistent navbar
    );
  }

  Widget _buildHeader() {
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
            const Text(
              "Hello, Matiny.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundImage:
              AssetImage("assets/mascot/icons.png"), // Profile picture
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.white),
          onPressed: () {},
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[900],
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFindProsButton(BuildContext context) { // ✅ Accept BuildContext
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FindProsPage()), // ✅ Navigate to FindProsPage
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
            Image.asset("assets/mascot/icons.png", height: 40), // ✅ Correct Path
            const SizedBox(width: 10),
            const Text(
              "Find Pros",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildOngoingProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Ongoing Project"),
        const SizedBox(height: 10),
        _buildProjectCard("Quoted", Icons.attach_money, Colors.yellow[700]!),
        const SizedBox(height: 10),
        _buildProjectCard("In Progress", Icons.work, Colors.blue),
      ],
    );
  }

  Widget _buildProjectCard(String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Project #9876",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "22 Jun - Jackson Hon",
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildFeaturedContractors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Featured Contractor"),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildContractorCard(
                  "assets/mascot/tv_greet.png"), // Corrected path
              const SizedBox(width: 10),
              _buildContractorCard(
                  "assets/mascot/tv_smile.png"), // Corrected path
              const SizedBox(width: 10),
              _buildContractorCard(
                  "assets/mascot/tv_cone_side.png"), // Corrected path
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
      ],
    );
  }
}
