import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quantocube/utils/project_service.dart';

class ProjectOverview extends StatefulWidget {
  const ProjectOverview({Key? key}) : super(key: key);

  @override
  _ProjectOverviewState createState() => _ProjectOverviewState();
}

class _ProjectOverviewState extends State<ProjectOverview> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = true;
  bool _hasMore = true;
  String? _currentUserId;
  bool _isHomeowner = false;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchUserInfo() async {
    try {
      // Get current user ID from Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user logged in.");
        setState(() => _isLoading = false);
        return;
      }
      _currentUserId = user.uid;

      // Fetch user data from Firestore to get isHomeowner status
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId)
          .get();

      if (userDoc.exists) {
        _isHomeowner = userDoc.data()?['isHomeowner'] ?? false;
      }

      print("User ID: $_currentUserId, isHomeowner: $_isHomeowner");

      // Fetch initial projects
      await _fetchProjects();
    } catch (e) {
      print("Error fetching user info: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchProjects() async {
    if (_isLoading || !_hasMore || _currentUserId == null) return;

    setState(() => _isLoading = true);

    try {
      List<Map<String, dynamic>> newProjects = await fetchOngoingProjects(
        currentUserId: _currentUserId!,
        isHomeowner: _isHomeowner,
        limit: 5,
        lastDocument: _lastDocument, // Pass last document for pagination
      );

      setState(() {
        if (newProjects.length < 5) _hasMore = false;
        _projects.addAll(newProjects);
        _lastDocument = newProjects.isNotEmpty
            ? newProjects.last['documentSnapshot']
            : null;
      });
    } catch (e) {
      print("Error fetching projects: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Project Overview"),
        backgroundColor: Colors.grey[900],
      ),
      body: _isLoading && _projects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _projects.length + 1,
              itemBuilder: (context, index) {
                if (index < _projects.length) {
                  final project = _projects[index];
                  return buildProjectCard(
                    context,
                    project["projectId"],
                    project["name"],
                    project["otherUserName"] ?? "Unknown",
                    project["status"],
                    project["createdAt"],
                  );
                } else {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
              },
            ),
    );
  }
}
