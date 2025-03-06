import 'package:flutter/material.dart';

class FindProsPage extends StatelessWidget {
  const FindProsPage({super.key});

  @override
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
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement Search Functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildFilterButton(),
            const SizedBox(height: 20),
            _buildSectionTitle("Featured Contractor"),
            const SizedBox(height: 10),
            _buildFeaturedContractors(),
            const SizedBox(height: 20),
            _buildSectionTitle("Category"),
            const SizedBox(height: 10),
            _buildCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.filter_alt, color: Colors.white),
        onPressed: () {
          // TODO: Implement Filter Functionality
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
      ],
    );
  }

  Widget _buildFeaturedContractors() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildContractorCard("Jackson Hon", "assets/contractors/contractor1.png", 4.6),
          const SizedBox(width: 10),
          _buildContractorCard("Joyce Leong", "assets/contractors/contractor2.png", 5.0),
        ],
      ),
    );
  }

  Widget _buildContractorCard(String name, String imagePath, double rating) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 3),
              Text(
                rating.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Renovations",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    List<Map<String, String>> categories = [
      {"title": "All", "image": "assets/categories/all.png"},
      {"title": "Renovations", "image": "assets/categories/renovations.png"},
      {"title": "Air Conditioning", "image": "assets/categories/air_conditioning.png"},
      {"title": "Installations", "image": "assets/categories/installations.png"},
      {"title": "Electrical", "image": "assets/categories/electrical.png"},
      {"title": "Plumbing", "image": "assets/categories/plumbing.png"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(categories[index]["title"]!, categories[index]["image"]!);
      },
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 60, fit: BoxFit.contain),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
