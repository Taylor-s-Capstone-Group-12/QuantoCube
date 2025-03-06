import 'package:flutter/material.dart';
import 'subcategory_page.dart'; // Import the subcategory navigation page

class FindProsPage extends StatefulWidget {
  const FindProsPage({super.key});

  @override
  _FindProsPageState createState() => _FindProsPageState();
}

class _FindProsPageState extends State<FindProsPage> {
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {"title": "All", "image": "assets/mascot/tv_smile.png", "subcategories": []},
    {
      "title": "Interior Painting",
      "image": "assets/mascot/tv_greet.png",
      "subcategories": [
        "Wall Painting",
        "Ceiling Painting",
        "Trim & Molding",
        "Decorative Painting",
        "Wallpaper Removal",
        "Custom Colors"
      ]
    },
    {
      "title": "Exterior Painting",
      "image": "assets/mascot/tv_cone_side.png",
      "subcategories": [
        "House Painting",
        "Deck Staining",
        "Fence Painting",
        "Garage Doors",
        "Shutters & Trims",
        "Waterproof Coating"
      ]
    },
    {
      "title": "Interior Design",
      "image": "assets/mascot/homeowner.png",
      "subcategories": [
        "Living Room Design",
        "Kitchen Layouts",
        "Bathroom Remodeling",
        "Furniture Placement",
        "Color Consultation",
        "Space Optimization"
      ]
    },
    {
      "title": "Flooring Installation",
      "image": "assets/mascot/icons.png",
      "subcategories": [
        "Hardwood Flooring",
        "Laminate Flooring",
        "Carpet Installation",
        "Tile Flooring",
        "Vinyl Flooring",
        "Stone Flooring"
      ]
    },
    {
      "title": "Cabinetry and Carpentry",
      "image": "assets/mascot/contractor.png",
      "subcategories": [
        "Custom Cabinets",
        "Closet Shelving",
        "Kitchen Cabinets",
        "Wood Trimming",
        "Furniture Repair",
        "Outdoor Woodwork"
      ]
    },
  ];

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: ListView(
            children: categories.map((category) {
              return ListTile(
                title: Text(
                  category["title"],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    selectedCategory = category["title"];
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _clearFilter() {
    setState(() {
      selectedCategory = null;
    });
  }

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
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  onPressed: _openFilterModal,
                ),
                if (selectedCategory != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedCategory!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: _clearFilter,
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            _buildCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final filteredCategories = selectedCategory == null
        ? categories
        : categories.where((c) => c["title"] == selectedCategory).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubcategoryPage(
                  categoryName: category["title"],
                  subcategories: category["subcategories"],
                ),
              ),
            );
          },
          child: _buildCategoryCard(category["title"], category["image"]),
        );
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
