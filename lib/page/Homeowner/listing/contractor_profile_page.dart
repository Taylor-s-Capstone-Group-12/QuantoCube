import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quantocube/components/components.dart';

class ContractorProfilePage extends StatefulWidget {
  final String contractorId;

  const ContractorProfilePage({super.key, required this.contractorId});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  Map<String, dynamic>? contractorData;
  List<Map<String, dynamic>> ratings = [];
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0.0;
  int totalRatings = 0;

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

      if (doc.exists) {
        setState(() {
          contractorData = doc.data();
        });
        _calculateReviewStats();
      } else {
        print("❌ Contractor not found");
      }
    } catch (e) {
      print("⚠ Error fetching contractor data: $e");
    }
  }

  void _calculateReviewStats() {
    if (contractorData == null) {
      print("ℹ No contractor data available for review stats calculation.");
      return;
    }

    Map<String, dynamic>? ratingsMap = contractorData?['ratings'];
    if (ratingsMap != null) {
      print("✅ Found ratings data: $ratingsMap");

      double totalRating = 0;
      int totalCount = 0;

      // Process ratings based on { "1": count, "2": count, ... }
      ratingsMap.forEach((key, value) {
        int ratingValue =
            int.tryParse(key) ?? 0; // Convert string keys ("1", "2") to int
        int count = value as int; // Count of ratings

        totalRating += ratingValue * count;
        totalCount += count;
      });

      double avgRating = totalCount > 0 ? totalRating / totalCount : 0.0;

      print("⭐ Total Ratings: $totalCount, Average Rating: $avgRating");

      setState(() {
        totalRatings = totalCount;
        averageRating = avgRating;
      });
    } else {
      print("ℹ No ratings data found.");
    }
  }

  Future<void> _fetchReviews() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contractorId)
          .collection('reviews')
          .get();

      setState(() {
        reviews = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print("⚠ Error fetching reviews: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          if (contractorData == null)
            Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                ProfileHeader(
                    data: contractorData!,
                    averageRating: averageRating,
                    totalRatings: totalRatings),
                const SizedBox(height: 16),
                ContractorActionBar(
                  data: contractorData!,
                  contractorId: widget.contractorId,
                ),
              ],
            ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 16),
                    InfoGrid(
                      contractorData: contractorData,
                      totalRatings: totalRatings,
                      averageRating: averageRating,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                    Text(
                      "${contractorData?['address']['houseNumber']}, ${contractorData?['address']['streetAddress']}, ${contractorData?['address']['zipCode']} ${contractorData?['address']['city']}, ${contractorData?['address']['state']}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "About",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                    Text(
                      contractorData?['about'] ?? 'No description available.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Reviews",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                    ...reviews.map((review) => Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review['user'] ?? 'Anonymous',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(review['comment'] ?? '',
                                  style: TextStyle(color: Colors.white70)),
                              SizedBox(height: 4),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text("⭐ ${review['rating'] ?? 'N/A'}",
                                    style: TextStyle(color: Colors.yellow)),
                              ),
                            ],
                          ),
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

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> data;
  final double averageRating;
  final int totalRatings;

  ProfileHeader(
      {required this.data,
      required this.averageRating,
      required this.totalRatings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProfilePicture(
          radius: 40,
          imageUrl: data['profilePicture'],
        ),
        SizedBox(height: 8),
        Text(
          data['name'] ?? 'Unknown',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Generate full stars
            ...List.generate(
              averageRating.floor(),
              (index) => Icon(Icons.star, color: Colors.yellow, size: 16),
            ),
            // Add a half-star if needed
            if (averageRating - averageRating.floor() >= 0.5)
              Icon(Icons.star_half, color: Colors.yellow, size: 16),
            SizedBox(width: 4), // Space between stars and text
            Text(
              "${averageRating.toStringAsFixed(1)} ($totalRatings)",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoGrid extends StatelessWidget {
  final Map<String, dynamic>? contractorData;
  final int totalRatings;
  final double averageRating;

  const InfoGrid({
    required this.contractorData,
    required this.totalRatings,
    required this.averageRating,
  });

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    DateTime date = timestamp.toDate();
    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (contractorData == null) return SizedBox.shrink();

    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2, // Decrease to make tiles taller
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      children: [
        _buildInfoTile(Icons.email, "Email", contractorData?['email'] ?? 'N/A'),
        _buildInfoTile(Icons.rate_review, "Reviews", "$totalRatings reviews"),
        _buildInfoTile(Icons.calendar_today, "Joined",
            _formatDate(contractorData?['createdAt'])),
        _buildInfoTile(Icons.star, "Average Rating",
            "${averageRating.toStringAsFixed(1)} ⭐"),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text(value,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContractorActionBar extends StatelessWidget {
  final Map<String, dynamic> data;
  final String contractorId;

  const ContractorActionBar({
    super.key,
    required this.data,
    required this.contractorId,
  });

  @override
  Widget build(BuildContext context) {
    RequestServiceArgs args = RequestServiceArgs(
      contractorId: contractorId,
      homeownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
    );

    return SizedBox(
      width: 161,
      child: DefaultSquareButton.onlyText(
        context,
        text: 'Hire',
        onPressed: () {
          Navigator.pushNamed(context, '/request_service', arguments: args);
        },
        height: 45,
      ),
    );
  }
}
