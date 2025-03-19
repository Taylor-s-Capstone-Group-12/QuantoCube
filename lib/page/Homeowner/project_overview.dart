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

  Future<void> _initializeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _currentUserId = user.uid;
    _isHomeowner = await _getUserType(_currentUserId);

    await _fetchProjects(initialLoad: true);
  }

  Future<bool> _getUserType(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) return false;

      dynamic isHomeownerValue = userDoc['isHomeowner'];
      if (isHomeownerValue is bool) return isHomeownerValue;
      if (isHomeownerValue is String)
        return isHomeownerValue.toLowerCase() == 'true';

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _fetchProjects({bool initialLoad = false}) async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    int fetchLimit = 9;
    try {
      List<Map<String, dynamic>> newProjects = await fetchOngoingProjects(
        currentUserId: _currentUserId,
        isHomeowner: _isHomeowner,
        limit: fetchLimit,
        lastDocument: _lastDocument,
      );

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
      debugPrint("❌ Error fetching projects: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchProjects();
    }
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final String projectId = project["projectId"];
    final String projectName = project["name"] ?? "Unnamed Project";
    final String otherUserName = project["otherUserName"] ?? "Unknown";
    final String status = project["status"] ?? "unknown";
    final Timestamp createdAt = project["createdAt"] ?? Timestamp.now();

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
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, color: Colors.white54),
        ),
        title: Text(projectName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              camelToThisCase(status), // ✅ Format status text
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            Text(
              "${_formatDate(createdAt)} • $otherUserName",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,
              color: Colors.white, size: 16),
          onPressed: () => Navigator.pushNamed(context, '/message',
              arguments: MessagePageArgs(projectId: projectId)),
        ),
      ),
    );
  }

  String camelToThisCase(String input) {
    return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirstMapped(RegExp(r'^\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text("Project Overview"),
          backgroundColor: Colors.grey[900]),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _projects.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _projects.isEmpty
                    ? const Center(
                        child: Text("No projects found",
                            style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _projects.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _projects.length) {
                            return _buildProjectCard(context, _projects[index]);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
