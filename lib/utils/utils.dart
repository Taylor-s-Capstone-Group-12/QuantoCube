import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:quantocube/tests/test_func.dart';

class Utils {
  static String getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (int i = 0; i < numWords; i++) {
      initials += names[i][0];
    }
    return initials;
  }

  static unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

Future<String?> getOtherUserName(bool isHomeowner, String projectId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get project document
    DocumentSnapshot projectDoc =
        await firestore.collection('projects').doc(projectId).get();

    if (!projectDoc.exists)
      return null; // If project doesn't exist, return null

    // Get the corresponding user ID (homeowner or contractor)
    String userId = isHomeowner
        ? projectDoc['contractorId'] as String? ?? ''
        : projectDoc['homeownerId'] as String? ?? '';

    if (userId.isEmpty) return null; // Return null if no user ID found

    // Get user document by retrieved userId
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) return null;

    return userDoc['name'] as String? ??
        'Unknown'; // Return the name or 'Unknown'
  } catch (e) {
    kPrint("Error fetching other user name: $e");
    return null; // Return null in case of error
  }
}

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
