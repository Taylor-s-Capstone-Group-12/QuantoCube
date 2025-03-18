import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quantocube/utils/project_service.dart';
import 'package:quantocube/components/components.dart';

class ProjectOverview extends StatefulWidget {
  const ProjectOverview({Key? key}) : super(key: key);

  @override
  _ProjectOverviewState createState() => _ProjectOverviewState();
}

class _ProjectOverviewState extends State<ProjectOverview> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentUserId = "";
  bool _isHomeowner = false;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    debugPrint("🔄 [initState] Initializing Project Overview...");
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  /// 📌 Step 1: Fetch User Data (User ID & Type)
  Future<void> _initializeData() async {
    debugPrint("📡 [INIT] Fetching user data...");

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("🚨 [INIT] No authenticated user found.");
        return;
      }

      _currentUserId = user.uid;
      debugPrint("✅ [INIT] User ID: $_currentUserId");

      _isHomeowner = await _getUserType(_currentUserId);
      debugPrint(
          "🏠 [INIT] User Type: ${_isHomeowner ? "Homeowner" : "Contractor"}");

      debugPrint("📡 [INIT] Fetching initial projects...");
      await _fetchProjects();
    } catch (e) {
      debugPrint("❌ [INIT] Error fetching user data: $e");
    }
  }

  /// 📌 Step 2: Determine User Type (Homeowner or Contractor)
  Future<bool> _getUserType(String uid) async {
    try {
      debugPrint("📡 [USER TYPE] Fetching user type for UID: $uid");
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        debugPrint("🚫 [USER TYPE] No user document found for UID: $uid");
        return false;
      }

      dynamic isHomeownerValue = userDoc['isHomeowner'];
      if (isHomeownerValue is bool) return isHomeownerValue;
      if (isHomeownerValue is String)
        return isHomeownerValue.toLowerCase() == 'true';

      debugPrint(
          "⚠️ [USER TYPE] Unexpected type for 'isHomeowner': $isHomeownerValue");
      return false;
    } catch (e) {
      debugPrint("❌ [USER TYPE] Error fetching user type: $e");
      return false;
    }
  }

  /// 📌 Step 3: Fetch Ongoing Projects
  Future<void> _fetchProjects() async {
    if (_isLoading || !_hasMore) {
      debugPrint(
          "⏳ [PROJECTS] Skipping fetch - Either still loading or no more projects.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    debugPrint("📡 [PROJECTS] Fetching projects (Limit: 5)...");

    try {
      List<Map<String, dynamic>> newProjects = await fetchOngoingProjects(
        currentUserId: _currentUserId,
        isHomeowner: _isHomeowner,
        limit: 5,
        lastDocument: _lastDocument,
      );

      debugPrint("📊 [PROJECTS] Fetched ${newProjects.length} projects");

      setState(() {
        if (newProjects.isEmpty) {
          _hasMore = false;
        } else {
          _projects.addAll(newProjects);
          _lastDocument =
              newProjects.last['documentSnapshot'] as DocumentSnapshot?;
        }
      });
    } catch (e) {
      debugPrint("❌ [PROJECTS] Error fetching projects: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 📌 Step 4: Infinite Scrolling
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      debugPrint("🔽 [SCROLL] Near bottom - Fetching more projects...");
      _fetchProjects();
    }
  }

  /// 📌 Step 5: Format Status
  String _formatStatus(String status) {
    if (status.isEmpty) return '';
    String spaced = status.replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'), (match) => ' ${match.group(0)}');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  /// 📌 Step 6: Format Date
  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.year}-${date.month}-${date.day}";
  }

  /// 📌 Step 7: Build Project Card UI
  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final String projectId = project["projectId"];
    final String projectName = project["name"] ?? "Unnamed Project";
    final String otherUserName = project["otherUserName"] ?? "Unknown";
    final String status = project["status"] ?? "unknown";
    final Timestamp createdAt = project["createdAt"] ?? Timestamp.now();

    debugPrint(
        "🎨 [UI] Building Project Card - ID: $projectId, Name: $projectName, Status: $status");

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(
          "assets/icons/project/$status.png",
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            debugPrint(
                "❌ [UI] Error loading project image for status: $status");
            return const Icon(Icons.image, color: Colors.white54);
          },
        ),
        title: Text(projectName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        subtitle: Text("${_formatDate(createdAt)} • $otherUserName",
            style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,
              color: Colors.white, size: 16),
          onPressed: () {
            debugPrint("➡ [UI] Navigating to Project Chat: $projectId");
            Navigator.pushNamed(
              context,
              '/message',
              arguments: MessagePageArgs(
                  projectId: projectId), // Pass the correct projectId
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "🔄 [UI] Rebuilding Project Overview | Projects Count: ${_projects.length}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text("Project Overview"),
          backgroundColor: Colors.grey[900]),
      body: _isLoading && _projects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _projects.isEmpty
              ? const Center(
                  child: Text("No projects found",
                      style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _projects.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _projects.length) {
                      return _buildProjectCard(context, _projects[index]);
                    } else {
                      return _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox();
                    }
                  },
                ),
    );
  }
}
