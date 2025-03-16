import 'package:flutter/material.dart';

class SubcategoryPage extends StatelessWidget {
  final String categoryTitle;

  const SubcategoryPage({super.key, required this.categoryTitle});

  // ✅ Define all subcategories for each category
  static final Map<String, List<String>> subcategories = {
    "Interior Painting": ["Wall Painting", "Ceiling Painting", "Trim & Molding", "Cabinet Refinishing", "Accent Walls", "Texture Finishing"],
    "Exterior Painting": ["House Painting", "Fence Painting", "Deck Staining", "Garage Doors", "Exterior Walls", "Roof Coating"],
    "Flooring Installation": ["Hardwood Flooring", "Tile Flooring", "Vinyl Flooring", "Carpet Installation", "Laminate Flooring", "Concrete Flooring"],
    "Interior Design": ["Furniture Selection", "Space Planning", "Color Consultation", "Lighting Design", "Custom Wall Art", "Home Styling"],
    "Cabinetry and Carpentry": ["Kitchen Cabinets", "Custom Shelves", "Bathroom Vanities", "Closet Organizers", "Entertainment Units", "Wood Carving"],
  };

  @override
  Widget build(BuildContext context) {
    // ✅ If "All" is selected, merge all subcategories into one list
    List<String> displaySubcategories = categoryTitle == "All"
        ? subcategories.values.expand((list) => list).toList()
        : subcategories[categoryTitle] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryTitle,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // ✅ Filter Section with category name & close button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  onPressed: () {},
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        categoryTitle,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ✅ Subcategories Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: displaySubcategories.length,
                itemBuilder: (context, index) {
                  return _buildSubcategoryCard(displaySubcategories[index]);
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  // ✅ Subcategory Card
  Widget _buildSubcategoryCard(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.build, color: Colors.white, size: 30), // Placeholder icon
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
