import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NameSearchPage extends StatefulWidget {
  @override
  _NameSearchPageState createState() => _NameSearchPageState();
}

class _NameSearchPageState extends State<NameSearchPage> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _contractors = []; // Store with distance
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchTerm = '';
  DocumentSnapshot? _lastDocument;
  GeoPoint? _currentUserLocation; // Store user's GeoPoint

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchUserLocation() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data()?['geo'] != null) {
        _currentUserLocation = doc.data()?['geo']['geopoint'];
        _fetchContractors();
      }
    } catch (e) {
      print("⚠ Error fetching user location: $e");
    }
  }

  Future<void> _fetchContractors({bool isNewSearch = false}) async {
    if (_isLoading || !_hasMore || _currentUserLocation == null) return;
    setState(() => _isLoading = true);

    Query query = _firestore
        .collection('users')
        .where('isHomeowner', isEqualTo: false)
        .orderBy('name')
        .limit(10);

    if (_lastDocument != null && !isNewSearch) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot snapshot = await query.get();
    List<DocumentSnapshot> newDocs = snapshot.docs;

    if (isNewSearch) {
      _contractors.clear();
      _lastDocument = null;
      _hasMore = true;
    }

    if (newDocs.isNotEmpty) {
      _lastDocument = newDocs.last;
    } else {
      _hasMore = false;
    }

    List<Map<String, dynamic>> tempContractors = [];

    for (var doc in newDocs) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null ||
          data['geo'] == null ||
          data['geo']['geopoint'] == null) {
        continue;
      }

      GeoPoint contractorLocation = data['geo']['geopoint'];
      double distance = _calculateDistance(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
        contractorLocation.latitude,
        contractorLocation.longitude,
      );

      tempContractors.add({
        'uuid': doc.id,
        'name': data['name'] ?? 'Unknown',
        'imageUrl': data['profileImage'] ?? '', // Contractor profile image
        'rating': data['rating'] ?? 4.6, // Default rating if missing
        'distance': distance, // Calculated distance
      });
    }

    tempContractors.sort((a, b) => a['distance'].compareTo(b['distance']));

    setState(() {
      _contractors.addAll(tempContractors);
      _isLoading = false;
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchContractors();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value.toLowerCase();
    });
    _fetchContractors(isNewSearch: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  _buildExpandableSection('Distance', _buildDistanceSlider()),
                  _buildExpandableSection('Rating', _buildRatingCheckboxes()),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Apply',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpandableSection(String title, Widget content) {
    return ExpansionTile(
      title: Text(title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: content),
      ],
    );
  }

  Widget _buildDistanceSlider() {
    RangeValues _distanceRange = RangeValues(10, 300);

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.orange,
                thumbColor: Colors.orange,
                overlayColor: Colors.orange.withOpacity(0.2),
              ),
              child: RangeSlider(
                values: _distanceRange,
                min: 10,
                max: 300,
                onChanged: (values) {
                  setState(() {
                    _distanceRange = values;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_distanceRange.start.toInt()} KM',
                    style: TextStyle(color: Colors.white)),
                Text('${_distanceRange.end.toInt()} KM',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingCheckboxes() {
    List<bool> _selectedRatings = List.generate(5, (index) => false);

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: List.generate(5, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex <= index ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    );
                  }),
                ),
                Checkbox(
                  value: _selectedRatings[index],
                  onChanged: (value) {
                    setState(() {
                      _selectedRatings[index] = value!;
                    });
                  },
                  activeColor: Colors.orange,
                ),
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredContractors =
        _contractors.where((contractor) {
      return contractor['name'].toLowerCase().contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Find Pros')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterMenu,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredContractors.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredContractors.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final contractor = filteredContractors[index];
                return ContractorCard(
                  name: contractor['name'],
                  imageUrl: contractor['imageUrl'],
                  distance: contractor['distance'],
                  rating: contractor['rating'],
                  category: 'Renovation',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/homeowner/contractor_profile_page',
                      arguments: contractor['uuid'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContractorCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double distance;
  final double rating;
  final String category;
  final VoidCallback onTap;

  const ContractorCard({
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.rating,
    required this.category,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl,
                      width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${distance.toStringAsFixed(1)} km',
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1),
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_forward, color: Colors.orange, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
