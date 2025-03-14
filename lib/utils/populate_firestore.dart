import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await populateDummyUsers();
}

Future<void> populateDummyUsers() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Random random = Random();

  // Base coordinates for generating random locations within 10km radius
  const double baseLat = 3.063611; // 3°03'49"N
  const double baseLng = 101.6175; // 101°37'03"E
  const double radiusKm = 10.0;

  for (int i = 0; i < 2; i++) {
    // Generate random name
    String name = "User${random.nextInt(9999)}";

    // Generate random email
    String email = "user${random.nextInt(99999)}@example.com";

    // Generate random phone number
    String phone = "01${random.nextInt(90000000) + 10000000}";

    // Generate random coordinates within a 10km radius
    double randomOffsetLat = (random.nextDouble() - 0.5) * (radiusKm / 111); // 1° ≈ 111km
    double randomOffsetLng = (random.nextDouble() - 0.5) * (radiusKm / (111 * cos(baseLat * pi / 180)));

    double lat = baseLat + randomOffsetLat;
    double lng = baseLng + randomOffsetLng;

    // Generate geohash using geoflutterfire_plus
    GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(lat, lng));

    // Dummy address
    Map<String, dynamic> address = {
      "houseNumber": "${random.nextInt(200)}",
      "streetAddress": "Jalan Example ${random.nextInt(50)}",
      "city": "Shah Alam",
      "zipCode": "40170",
      "state": "Selangor",
      "phoneNumber": phone,
    };

    // User data to store in Firestore
    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
      "isHomeowner": false, // Always false for this script
      "address": address,
      "geo": geoFirePoint.data, // Geolocation with geohash
    };

    // Save to Firestore under "users" collection
    await firestore.collection("users").doc().set(userData);
    print("Added user: $name at [$lat, $lng]");
  }

  print("✅ Successfully populated 20 dummy users.");
}
