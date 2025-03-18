import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔹 Fetch Ongoing Projects with Pagination
Future<List<Map<String, dynamic>>> fetchOngoingProjects({
  required String currentUserId,
  required bool isHomeowner,
  int limit = 5,
  DocumentSnapshot? lastDocument, // ✅ Added lastDocument for pagination
}) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> projects = [];

  try {
    String userField = isHomeowner ? "homeownerId" : "contractorId";
    String otherUserField = isHomeowner ? "contractorId" : "homeownerId";

    print("🔍 Searching projects where $userField == $currentUserId");

    // ✅ 1️⃣ Query latest projects where user is homeowner/contractor
    Query query = _firestore
        .collection("projects")
        .where(userField, isEqualTo: currentUserId)
        .orderBy("createdAt", descending: true)
        .limit(limit);

    // ✅ If we have a lastDocument, start after it for pagination
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot projectSnapshot = await query.get();
    print("📂 Found ${projectSnapshot.docs.length} matching projects");

    if (projectSnapshot.docs.isEmpty) return [];

    // ✅ Store the last document for pagination
    DocumentSnapshot? newLastDocument =
        projectSnapshot.docs.isNotEmpty ? projectSnapshot.docs.last : null;

    // ✅ 2️⃣ Fetch project details & Other User Name
    List<Future<Map<String, dynamic>?>> projectDetailsFutures =
        projectSnapshot.docs.map((doc) {
      Map<String, dynamic> projectData = doc.data() as Map<String, dynamic>;
      String otherUserId = projectData[otherUserField] ?? "";

      return _fetchProjectDetails(
        _firestore,
        doc.id,
        projectData["createdAt"] ?? Timestamp.now(),
        otherUserId,
      ).then((projectDetails) {
        if (projectDetails != null) {
          projectDetails["documentSnapshot"] = doc; // ✅ Save last document
        }
        return projectDetails;
      });
    }).toList();

    // ✅ 3️⃣ Wait for all data fetches to complete
    List<Map<String, dynamic>?> results =
        await Future.wait(projectDetailsFutures);
    projects =
        results.where((project) => project != null).map((e) => e!).toList();

    print("📊 Retrieved ${projects.length} project details");

    // ✅ Return projects with lastDocument info
    return projects;
  } catch (e) {
    print("⚠ Error fetching projects: $e");
    return [];
  }
}

/// 🔹 Fetch Project Details from "data" subcollection + Fetch Other User's Name
Future<Map<String, dynamic>?> _fetchProjectDetails(FirebaseFirestore firestore,
    String projectId, Timestamp parentCreatedAt, String otherUserId) async {
  try {
    print("🔍 Fetching 'details' document for project: $projectId");

    DocumentSnapshot detailsDoc = await firestore
        .collection("projects")
        .doc(projectId)
        .collection("data")
        .doc("details")
        .get();

    if (!detailsDoc.exists) {
      print("❌ No 'details' document found for project: $projectId");
      return null;
    }

    Map<String, dynamic> detailsData =
        detailsDoc.data() as Map<String, dynamic>;

    print("✅ Found 'name': ${detailsData["name"]} for project: $projectId");

    String otherUserName = await _fetchUserName(firestore, otherUserId);

    return {
      "projectId": projectId,
      "name": detailsData["name"] ?? "Unnamed Project",
      "createdAt": parentCreatedAt,
      "status": detailsData["status"] ?? "Unknown",
      "otherUserName": otherUserName,
    };
  } catch (e) {
    print("⚠ Error fetching 'details' document for $projectId: $e");
    return null;
  }
}

/// 🔹 Fetch Other User's Name from Users Collection
Future<String> _fetchUserName(
    FirebaseFirestore firestore, String userId) async {
  try {
    if (userId.isEmpty) {
      print("⚠ No other user ID provided");
      return "Unknown User";
    }

    print("🔍 Fetching user name for userId: $userId");

    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(userId).get();

    if (!userDoc.exists) {
      print("❌ No user found with ID: $userId");
      return "Unknown User";
    }

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData["name"] ?? "Unnamed User";
  } catch (e) {
    print("⚠ Error fetching user name for ID: $userId - $e");
    return "Unknown User";
  }
}

/// 🔹 Format Timestamp to Readable Date
String formatDate(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return "${date.day} ${_getMonthName(date.month)} ${date.year}";
}

/// 🔹 Convert Month Number to Name
String _getMonthName(int month) {
  const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  return months[month - 1];
}
