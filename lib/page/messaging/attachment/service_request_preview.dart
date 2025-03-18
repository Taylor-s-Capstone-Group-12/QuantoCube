import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/utils/utils.dart';

class ServiceRequestPreviewPage extends StatefulWidget {
  const ServiceRequestPreviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<ServiceRequestPreviewPage> createState() =>
      _ServiceRequestPreviewPageState();
}

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class _ServiceRequestPreviewPageState extends State<ServiceRequestPreviewPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<LoadingOverlayState> _overlayKey =
      GlobalKey<LoadingOverlayState>();
  bool isLoading = true;

  final Map<String, String> _projectHeader = {
    'title': '',
    'homeowner': '',
    'createdAt': '',
  };

  final Map<String, String> _projectDetails = {
    'createdAt': '',
    'service': '',
    'details': '',
    'location': '',
    'startDate': '',
    'endDate': '',
    'additionalComment': '',
  };

  @override
  void initState() {
    assignProjectInfo();
    super.initState();
  }

  Future<void> assignProjectInfo() async {
    _overlayKey.currentState?.show();

    final DocumentSnapshot projectInfoSnapshot =
        await _firestore.collection('projects').doc(widget.projectId).get();

    final DocumentSnapshot projectDetailsSnapshot = await _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('data')
        .doc('details')
        .get();

    if (projectInfoSnapshot.exists && projectDetailsSnapshot.exists) {
      final Map<String, dynamic> projectInfoData =
          projectInfoSnapshot.data() as Map<String, dynamic>;
      final Map<String, dynamic> projectDetailsData =
          projectDetailsSnapshot.data() as Map<String, dynamic>;

      _projectHeader['title'] = projectDetailsData['name'] ?? 'Unnamed Project';
      _projectHeader['homeowner'] =
          await getNameFromId(projectInfoData['homeownerId']) ?? 'Unknown';
      _projectHeader['createdAt'] =
          (projectInfoData['createdAt'] as Timestamp).toDate().toString();

      _projectDetails['createdAt'] =
          (projectInfoData['createdAt'] as Timestamp).toDate().toString();
      _projectDetails['service'] = projectDetailsData['service'] ?? '';
      _projectDetails['details'] = projectDetailsData['details'] ?? '';
      _projectDetails['location'] = projectDetailsData['location'] ?? '';
      _projectDetails['startDate'] =
          (projectDetailsData['startDate'] as Timestamp).toDate().toString();
      _projectDetails['endDate'] =
          (projectDetailsData['endDate'] as Timestamp).toDate().toString();
      _projectDetails['additionalComment'] =
          projectDetailsData['additionalComment'] ?? '';

      print('====================');
      _projectHeader.forEach((key, value) {
        print('$key: $value');
      });
      print('====================');

      print('====================');
      _projectDetails.forEach((key, value) {
        print('$key: $value');
      });
      print('====================');

      _overlayKey.currentState?.hide();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Project not found');
    }
  }

  void onDecline() {}

  void onAccept() {}

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleBar(
                    projectHeader: _projectHeader,
                    onDecline: onDecline,
                    onAccept: onAccept,
                  ),
                ],
              ),
            ),
          );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
    required this.projectHeader,
    required this.onDecline,
    required this.onAccept,
  });

  final Map<String, String> projectHeader;
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(left: 30, top: 84, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: IconButton(
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary,
                size: 35,
              ),
            ),
          ),
          Text(
            projectHeader['title'] ?? 'Unnamed Project',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Request from ${projectHeader['homeowner']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Created',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            projectHeader['createdAt']!,
            style: const TextStyle(
              color: Color(0xFF8F9193),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                DefaultSquareButton.onlyText(context,
                    onPressed: onDecline, text: 'Decline'),
                const SizedBox(width: 10),
                DefaultSquareButton.onlyText(context,
                    onPressed: onAccept, text: 'Accept'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
