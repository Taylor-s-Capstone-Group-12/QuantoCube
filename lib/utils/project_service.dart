import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔹 Fetch Ongoing Projects (Sorted by CreatedAt)
Future<List<Map<String, dynamic>>> fetchOngoingProjects({
  required String currentUserId,
  required bool isHomeowner,
  int limit = 3,
}) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> projects = [];

  try {
    String userField = isHomeowner ? "homeownerId" : "contractorId";

    print("🔍 Searching projects where $userField == $currentUserId");

    // 1️⃣ Query projects where user is homeowner/contractor, sorted by `createdAt`
    QuerySnapshot projectSnapshot = await _firestore
        .collection("projects")
        .where(userField, isEqualTo: currentUserId)
        .orderBy("createdAt", descending: true) // Sort by latest
        .limit(10) // Fetch only the latest 3 projects
        .get();

    print("📂 Found ${projectSnapshot.docs.length} matching projects");

    if (projectSnapshot.docs.isEmpty) return []; // No projects found

    // 2️⃣ Store project IDs
    List<String> projectIds =
        projectSnapshot.docs.map((doc) => doc.id).toList();
    print("📝 Stored Project IDs: $projectIds");

    // 3️⃣ Fetch project details from "data" subcollection
    List<Future<Map<String, dynamic>?>> projectDetailsFutures =
        projectIds.map((projectId) {
      return _fetchProjectDetails(_firestore, projectId);
    }).toList();

    // 4️⃣ Wait for all data fetches to complete
    List<Map<String, dynamic>?> results =
        await Future.wait(projectDetailsFutures);
    projects =
        results.where((project) => project != null).map((e) => e!).toList();

    print("📊 Retrieved ${projects.length} project details");

    return projects;
  } catch (e) {
    print("⚠ Error fetching projects: $e");
    return [];
  }
}

/// 🔹 Fetch Project Details from "data" subcollection
Future<Map<String, dynamic>?> _fetchProjectDetails(
    FirebaseFirestore firestore, String projectId) async {
  try {
    print("🔍 Fetching details for project: $projectId");

    QuerySnapshot dataSnapshot = await firestore
        .collection("projects")
        .doc(projectId)
        .collection("data")
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get(); 

    if (dataSnapshot.docs.isEmpty) {
      print("❌ No 'data' found for project: $projectId");
      return null;
    }

    var detailsDoc = dataSnapshot.docs.first;

    print("✅ Found details for project: $projectId");

    return {
      "name": detailsDoc["name"] ?? "Unnamed Project",
      "createdAt": detailsDoc["createdAt"] ?? Timestamp.now(),
      "status": detailsDoc["status"] ?? "Unknown",
    };
  } catch (e) {
    print("⚠ Error fetching project details for $projectId: $e");
    return null;
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
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}
