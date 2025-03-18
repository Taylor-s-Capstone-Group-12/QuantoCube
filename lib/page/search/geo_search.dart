import 'dart:math'; // ✅ Import for manual distance calculations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class GeoSearchPage extends StatefulWidget {
  @override
  _GeoSearchPageState createState() => _GeoSearchPageState();
}

class _GeoSearchPageState extends State<GeoSearchPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final LatLng _defaultCenter =
      const LatLng(3.1390, 101.6869); // KL Coordinates
  LatLng? _currentUserLocation;
  double _selectedDistance = 20.0; // Default radius (km)

  // 1) Add a list to hold nearby users for the bottom carousel
  List<Map<String, dynamic>> _nearbyUsers = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchUserLocation();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserLocation() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print("❌ No user logged in.");
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists && doc.data()?['geo'] != null) {
        final GeoPoint geoPoint = doc.data()?['geo']['geopoint'];
        _currentUserLocation = LatLng(geoPoint.latitude, geoPoint.longitude);

        print("✅ Fetched user location: $_currentUserLocation");

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(userId),
              position: _currentUserLocation!,
              infoWindow: InfoWindow(title: "You"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            ),
          );

          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(_currentUserLocation!, 11.0),
          );
        });

        // Fetch users after getting current location
        _fetchNearbyUsers();
      } else {
        print("❌ User location not found in Firestore.");
      }
    } catch (e) {
      print("⚠ Error fetching user location: $e");
    }
  }

  Future<void> _fetchNearbyUsers() async {
    if (_currentUserLocation == null) {
      print("⚠ _fetchNearbyUsers called but _currentUserLocation is null!");
      return;
    }

    print("🔍 Searching users within ${_selectedDistance.toInt()} km");

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
      radiusInKm: _selectedDistance / 3.506, // ✅ Correction factor applied
      field: 'geo',
      geopointFrom: geopointFrom,
    );

    stream.listen((docs) {
      print("📌 Found ${docs.length} users before filtering");
      int filteredCount = 0;
      int totalCount = docs.length;

      final List<Map<String, dynamic>> tempUsers = [];

      setState(() {
        _markers.removeWhere((marker) =>
            marker.markerId.value != FirebaseAuth.instance.currentUser?.uid);

        for (var doc in docs) {
          final data = doc.data();
          if (data == null) continue;

          try {
            final GeoPoint geopoint = geopointFrom(data);
            final LatLng position =
                LatLng(geopoint.latitude, geopoint.longitude);
            final String username = data['name'] ?? 'Unknown';

            // ✅ Skip adding the logged-in user
            if (doc.id == FirebaseAuth.instance.currentUser?.uid) {
              continue;
            }

            // ✅ Apply manual distance filtering
            final double actualDistance = _calculateDistance(
              _currentUserLocation!.latitude,
              _currentUserLocation!.longitude,
              position.latitude,
              position.longitude,
            );

            if (actualDistance <= _selectedDistance) {
              print(
                "✅ User in range (${actualDistance.toStringAsFixed(2)} km): $username",
              );

              tempUsers.add({
                'uuid': doc.id,
                'name': username,
                'distance': actualDistance,
                'role': 'Renovator', // Placeholder
                'rating': 4.6, // Placeholder rating
              });

              _markers.add(
                Marker(
                  markerId: MarkerId(doc.id),
                  position: position,
                  infoWindow: InfoWindow(title: username),
                ),
              );
            } else {
              print(
                "❌ User filtered out (${actualDistance.toStringAsFixed(2)} km): $username",
              );
              filteredCount++;
            }
          } catch (e) {
            print("⚠ Error processing user ${doc.id}: $e");
          }
        }

        // Sort the temp list by distance, nearest first
        tempUsers.sort((a, b) => a['distance'].compareTo(b['distance']));
        _nearbyUsers = tempUsers;

        print("🔎 Debug: $filteredCount filtered out of $totalCount users");
      });
    });
  }

  /// **Haversine Formula** to calculate true distance (in km) between two coordinates
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0; // Earth radius in km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }


void _flashMarker(String markerId) async {
  // Find the marker
  Marker? targetMarker = _markers.firstWhere(
    (marker) => marker.markerId.value == markerId,
    orElse: () => Marker(markerId: MarkerId('not_found')),
  );

  if (targetMarker.markerId.value == 'not_found') {
    print("❌ Marker not found!");
    return;
  }

  LatLng position = targetMarker.position;

  // Define the colors to flash between
  List<BitmapDescriptor> colors = [
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ];

  for (int i = 0; i < 4; i++) {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == markerId);
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: colors[i % 2], // Alternate between two colors
        ),
      );
    });

    await Future.delayed(Duration(milliseconds: 300)); // Delay between flashes
  }

  // Restore original marker
  setState(() {
    _markers.removeWhere((m) => m.markerId.value == markerId);
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        icon: BitmapDescriptor.defaultMarker, // Restore original color
      ),
    );
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Location'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Stack(
        children: [
          // 3) Keep your original GoogleMap and distance UI
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _defaultCenter,
              zoom: 11.0,
            ),
            markers: _markers,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "Distance: ${_selectedDistance.toInt()} km",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Slider(
                    value: _selectedDistance,
                    min: 10,
                    max: 30,
                    divisions: 20, // 5km steps (5, 10, 15, ... 50)
                    label: "${_selectedDistance.toStringAsFixed(2)} km",
                    activeColor: Color(0xFFFE5823), // Orange
                    inactiveColor: Colors.white30,
                    onChanged: (double value) {
                      setState(() {
                        _selectedDistance = value;
                      });
                      print(
                          "📏 Distance slider changed: ${_selectedDistance.toInt()} km");
                      _fetchNearbyUsers(); // Re-fetch users when slider changes
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4) Add the carousel overlay at the bottom
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              height: 160, // adjust as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _nearbyUsers.length,
                itemBuilder: (context, index) {
                  final user = _nearbyUsers[index];
                  return _buildCarouselCard(user);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5) Helper widget to build each carousel card
  Widget _buildCarouselCard(Map<String, dynamic> user) {
  return Container(
    width: 220,
    margin: EdgeInsets.symmetric(horizontal: 8),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/avatar_placeholder.png'),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user['role'] ?? 'Role',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          user['name'] ?? 'Unknown',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Ad • ${user['distance']?.toStringAsFixed(1) ?? '--'} km  ★ ${user['rating'] ?? '--'}',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        SizedBox(height: 5),

        // New Locate Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.my_location, color: Colors.blueAccent),
              onPressed: () {
                String contractorId = user['uuid'];
                
                // ✅ Find the matching marker in _markers 
                Marker? contractorMarker = _markers.firstWhere(
                  (marker) => marker.markerId.value == contractorId,
                  orElse: () => Marker(markerId: MarkerId('not_found')), // Fallback
                );

                if (contractorMarker.markerId.value != 'not_found') {
                  print("📍 Moving camera to contractor ${user['name']}");
    
                  mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(contractorMarker.position, 14.0),
                  );

                   _flashMarker(user['uuid']);
                } else {
                  print("❌ Contractor marker not found!");
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward, color: Color(0xFFFE5823)),
              onPressed: () {
                if (user['uuid'] != null) {
                  Navigator.pushNamed(
                    context,
                    '/homeowner/contractor_profile_page',
                    arguments: user['uuid'],
                  );
                }
              },
            ),
          ],
        ),
      ],
    ),
  );
}
}
