import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/homeowner_homepage.dart';
import 'package:quantocube/page/Homeowner/find_pros.dart';
import 'package:quantocube/page/Homeowner/project_page.dart';


class HomeownerHomePage extends StatelessWidget {
  const HomeownerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              _buildHeader(),
              const SizedBox(height: 15),
              _buildSearchBar(context),
              const SizedBox(height: 20),
              _buildFindProsButton(context),
              const SizedBox(height: 20),
              _buildOngoingProjects(),
              const SizedBox(height: 20),
              _buildFeaturedContractors(),
              const SizedBox(height: 20),
              _buildServiceCategories(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
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

  Widget _buildOngoingProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ongoing Project",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProjectPage()),
        );
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
