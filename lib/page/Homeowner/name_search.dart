import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class NameSearchPage extends StatefulWidget {
  @override
  _NameSearchPageState createState() => _NameSearchPageState();
}

class _NameSearchPageState extends State<NameSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _contractors = [];
  List<Map<String, dynamic>> _filteredContractors = [];
  String _searchTerm = '';
  GeoPoint? _currentUserLocation;
  double _distanceMin = 0;
  double _distanceMax = 50;

  List<bool> _selectedRatings = List.generate(5, (index) => false);

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
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

  Future<void> _fetchContractors() async {
    if (_currentUserLocation == null) {
      print("⚠ _fetchContractors called but _currentUserLocation is null!");
      return;
    }

    print(
        "🔍 Searching contractors between ${_distanceMin.toInt()} km and ${_distanceMax.toInt()} km");

    final collectionReference = FirebaseFirestore.instance.collection('users');
    final GeoFirePoint center = GeoFirePoint(
      GeoPoint(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
      ),
    );

    GeoPoint geopointFrom(Map<String, dynamic> data) {
      if (data.containsKey('geo') &&
          data['geo'] is Map<String, dynamic> &&
          data['geo'].containsKey('geopoint')) {
        return data['geo']['geopoint'] as GeoPoint;
      }
      throw Exception(
          "❌ Invalid location data for ${data['name'] ?? 'Unknown'}");
    }

    final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
        GeoCollectionReference<Map<String, dynamic>>(collectionReference)
            .subscribeWithin(
      center: center,
      radiusInKm: _distanceMax / 2.506, // ✅ Correction factor applied
      field: 'geo',
      geopointFrom: geopointFrom,
    );

    stream.listen((docs) {
      print("📌 Found ${docs.length} contractors before filtering");
      int filteredOutMin = 0;
      int filteredOutMax = 0;
      int totalCount = docs.length;

      final List<Map<String, dynamic>> tempContractors = [];

      setState(() {
        for (var doc in docs) {
          final data = doc.data();
          if (data == null || data['isHomeowner'] == true) {
            continue; // ✅ Ensure only contractors
          }

          try {
            final GeoPoint geopoint = geopointFrom(data);
            final double lat = geopoint.latitude;
            final double lon = geopoint.longitude;
            final String username = data['name'] ?? 'Unknown';

            // ✅ Apply manual distance filtering
            final double actualDistance = _calculateDistance(
              _currentUserLocation!.latitude,
              _currentUserLocation!.longitude,
              lat,
              lon,
            );

            if (actualDistance >= _distanceMin &&
                actualDistance <= _distanceMax) {
              print(
                  "✅ Contractor in range (${actualDistance.toStringAsFixed(2)} km): $username");

              // ✅ Calculate rating
              final Map<String, dynamic>? ratingsMap = data['ratings'];
              double avgRating = 0.0;
              int totalRatings = 0;

              if (ratingsMap != null) {
                double totalRating = 0;
                ratingsMap.forEach((key, value) {
                  int ratingValue = int.tryParse(key) ?? 0;
                  int count = value as int;

                  totalRating += ratingValue * count;
                  totalRatings += count;
                });

                avgRating = totalRatings > 0 ? totalRating / totalRatings : 0.0;
              }

              // 🔹 Debugging: Print rating comparison for each contractor
              // 🔹 Debugging: Print rating comparison for each contractor
              print("🔍 Checking rating for $username:");
              print("   - avgRating: ${avgRating.toStringAsFixed(2)}");
              print("   - Total Ratings: $totalRatings");
              print("   - _selectedRatings: $_selectedRatings");
              if (_selectedRatings.every((element) => element == false)) {
                print("🔹 No rating filter selected, enabling all ratings.");
                _selectedRatings = List.generate(5, (_) => true);
              }

              // ✅ Apply rating filter (each star level includes up to the next full number)
              bool isInSelectedRange = false;
              for (int i = 0; i < _selectedRatings.length; i++) {
                if (_selectedRatings[i]) {
                  double minRating = (i == 0) ? 0.0 : i.toDouble();
                  double maxRating = (i + 1).toDouble();

                  if (avgRating >= minRating && avgRating < maxRating) {
                    print(
                        "   ✅ Rating ${avgRating.toStringAsFixed(2)} falls in [$minRating, $maxRating), adding $username.");
                    isInSelectedRange = true;
                    break; // ✅ Stop checking once matched
                  }
                }
              }

              if (isInSelectedRange) {
                tempContractors.add({
                  'uuid': doc.id,
                  'name': username,
                  'imageUrl': data['profileImage'] ?? '',
                  'rating': avgRating,
                  'totalRatings': totalRatings,
                  'distance': actualDistance,
                });
              } else {
                print("   ❌ Skipping $username due to rating filter.");
              }
            } else {
              if (actualDistance < _distanceMin) {
                print(
                    "❌ Contractor too close (${actualDistance.toStringAsFixed(2)} km): $username");
                filteredOutMin++;
              } else {
                print(
                    "❌ Contractor too far (${actualDistance.toStringAsFixed(2)} km): $username");
                filteredOutMax++;
              }
            }
          } catch (e) {
            print("⚠ Error processing contractor ${doc.id}: $e");
          }
        }

        // Sort contractors by distance (nearest first)
        tempContractors.sort((a, b) => a['distance'].compareTo(b['distance']));
        _contractors = tempContractors;
        _filteredContractors = _contractors; // ✅ Sync with filtered list

        print(
            "🔎 Debug: $filteredOutMin too close, $filteredOutMax too far out of $totalCount contractors");
      });
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

// 🔍 Instant search filtering (no refetch needed)
  void _applySearchFilter() {
    setState(() {
      _filteredContractors = _contractors.where((contractor) {
        return contractor['name'].toLowerCase().contains(_searchTerm);
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value.toLowerCase();
      _applySearchFilter(); // ✅ Apply search + rating filters together
    });
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
                  _buildExpandableSection(
                      'Distance', _buildDistanceSlider(setModalState)),
                  _buildExpandableSection('Rating', _buildRatingCheckboxes()),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _fetchContractors();
                      });
                      Navigator.pop(context);
                    },
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

  Widget _buildDistanceSlider(Function setModalState) {
    double sliderMin = 0;
    double sliderMax = 50;
    int sliderSteps = (sliderMax - sliderMin).toInt();

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            thumbColor: Colors.orange,
            overlayColor: Colors.orange.withOpacity(0.2),
            valueIndicatorColor: Colors.orange,
            showValueIndicator: ShowValueIndicator.always, // Always show bubble
          ),
          child: RangeSlider(
            values: RangeValues(_distanceMin, _distanceMax),
            min: sliderMin,
            max: sliderMax,
            divisions: sliderSteps, // 1 KM steps
            labels: RangeLabels(
              '${_distanceMin.toInt()} KM',
              '${_distanceMax.toInt()} KM',
            ),
            onChanged: (values) {
              setModalState(() {
                _distanceMin = values.start;
                _distanceMax = values.end;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${sliderMin.toInt()} KM',
                style: TextStyle(color: Colors.white)), // Min allowed
            Text('${sliderMax.toInt()} KM',
                style: TextStyle(color: Colors.white)), // Max allowed
          ],
        ),
      ],
    );
  }

  Widget _buildRatingCheckboxes() {
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
                      fillColor: const Color.fromRGBO(28, 28, 28, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged:
                        _onSearchChanged, // ✅ Call this method when text changes
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
              itemCount: filteredContractors.length,
              itemBuilder: (context, index) {
                final contractor = filteredContractors[index];
                return ContractorCard(
                  name: contractor['name'],
                  imageUrl: contractor['imageUrl'],
                  distance: contractor['distance'],
                  rating:
                      contractor['rating'], // ✅ Pass calculated average rating
                  totalRatings: contractor[
                      'totalRatings'], // ✅ Pass total number of ratings
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
  final int totalRatings;
  final String category;
  final VoidCallback onTap;

  const ContractorCard({
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.rating,
    required this.totalRatings,
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
          color: Color.fromARGB(255, 28, 28, 28),
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
                      _buildStarRating(rating), // ✅ Rating stars
                      SizedBox(width: 4),
                      Text(
                        "${rating.toStringAsFixed(1)} (${totalRatings})", // ✅ Format as "x.x(x)"
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double averageRating) {
    List<Widget> stars = [];

    // Full stars
    stars.addAll(List.generate(
      averageRating.floor(),
      (index) => Icon(Icons.star, color: Colors.yellow, size: 16),
    ));

    // Half-star if needed
    if (averageRating - averageRating.floor() >= 0.5) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow, size: 16));
    }

    // Ensure 5-star layout by adding empty stars
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.yellow, size: 16));
    }

    return Row(children: stars);
  }
}
