import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContractorProfilePage extends StatefulWidget {
  final String contractorId;
  
  const ContractorProfilePage({super.key, required this.contractorId});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  Map<String, dynamic>? contractorData;
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchContractorData();
  }

  Future<void> _fetchContractorData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contractorId)
          .get();

      if (doc.exists && doc.data() != null) {
        if (mounted) {
          setState(() {
            contractorData = doc.data();
          });
        }
        _fetchReviews();
      } else {
        print("❌ Contractor not found");
        if (mounted) {
          setState(() {
            contractorData = {}; 
          });
        }
      }
    } catch (e) {
      print("⚠ Error fetching contractor data: $e");
      if (mounted) {
        setState(() {
          contractorData = {}; 
        });
      }
    }
  }

  Future<void> _fetchReviews() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contractorId)
          .collection('reviews')
          .get();

      if (mounted) {
        setState(() {
          reviews = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (e) {
      print("⚠ Error fetching reviews: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contractorData?['name'] ?? 'Contractor Profile'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      contractorData?['name'] ?? 'Loading...',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Location: ${contractorData?['location'] ?? 'Unknown'}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "About",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      contractorData?['about'] ?? 'No description available.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Reviews",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    ...reviews.map((review) => ListTile(
                          title: Text(review['user'] ?? 'Anonymous', style: TextStyle(color: Colors.white)),
                          subtitle: Text(review['comment'] ?? '', style: TextStyle(color: Colors.white70)),
                          trailing: Text("⭐ ${review['rating'] ?? 'N/A'}", style: TextStyle(color: Colors.yellow)),
                        )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
