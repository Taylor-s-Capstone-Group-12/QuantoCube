import 'package:flutter/material.dart';

class SubcategoryPage extends StatelessWidget {
  final String categoryName;
  final List<String> subcategories;

  const SubcategoryPage({super.key, required this.categoryName, required this.subcategories});

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
        title: Text(
          categoryName,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subcategories[index], style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
            onTap: () {
              // TODO: Navigate to the respective professionals list for this subcategory
            },
          );
        },
      ),
    );
  }
}
