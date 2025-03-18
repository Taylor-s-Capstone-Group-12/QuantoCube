import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> getUserType(String uid) async {
  try {
    // Reference to Firestore users collection
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      // Retrieve the 'userType' field and check if it is 'homeowner'
      String userType = userDoc['userType'] as String? ?? '';
      return userType == 'homeowner';
    } else {
      return false; // User not found
    }
  } catch (e) {
    print("Error fetching user type: $e");
    return false; // Return false in case of an error
  }
}
