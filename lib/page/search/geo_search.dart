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
  double _selectedDistance = 10.0; // Default radius (km)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchUserLocation();
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
            ),
          );

          mapController.animateCamera(
              CameraUpdate.newLatLngZoom(_currentUserLocation!, 11.0));
        });

        _fetchNearbyUsers(); // Fetch users after getting current location
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

    final GeoFirePoint center = GeoFirePoint(GeoPoint(
      _currentUserLocation!.latitude,
      _currentUserLocation!.longitude,
    ));

    GeoPoint geopointFrom(Map<String, dynamic> data) {
      if (data.containsKey('geo') &&
          data['geo'] is Map<String, dynamic> &&
          data['geo'].containsKey('geopoint')) {
        return data['geo']['geopoint'] as GeoPoint;
      }
      throw Exception(
          "❌ Invalid location data for ${data['name'] ?? 'Unknown'}");
    }

    // ✅ Apply correction factor (÷3.506) in query
    final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
        GeoCollectionReference<Map<String, dynamic>>(collectionReference)
            .subscribeWithin(
      center: center,
      radiusInKm: _selectedDistance / 3.506,
      field: 'geo',
      geopointFrom: geopointFrom,
    );

    stream.listen((docs) {
      print("📌 Found ${docs.length} users before filtering");
      int filteredCount = 0;
      int totalCount = docs.length;

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

            // ✅ Apply manual distance filtering
            final double actualDistance = _calculateDistance(
              _currentUserLocation!.latitude,
              _currentUserLocation!.longitude,
              position.latitude,
              position.longitude,
            );

            if (actualDistance <= _selectedDistance) {
              print(
                  "✅ User in range (${actualDistance.toStringAsFixed(2)} km): $username");

              _markers.add(
                Marker(
                  markerId: MarkerId(doc.id),
                  position: position,
                  infoWindow: InfoWindow(title: username),
                ),
              );
            } else {
              print(
                  "❌ User filtered out (${actualDistance.toStringAsFixed(2)} km): $username");
              filteredCount++;
            }
          } catch (e) {
            print("⚠ Error processing user ${doc.id}: $e");
          }
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Location'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Slider(
                    value: _selectedDistance,
                    min: 10,
                    max: 50,
                    divisions: 40, // 5km steps (5, 10, 15, ... 50)
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
        ],
      ),
    );
  }
}
