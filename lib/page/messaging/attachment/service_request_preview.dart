import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool isHomeowner = false;

  final Map<String, String> _projectHeader = {
    'title': '',
    'homeowner': '',
    'createdAt': '',
  };

  final Map<String, String> _projectDetails = {
    'budgetMax': '',
    'budgetMin': '',
    'comments': '',
    'createdAt': '',
    'endDate': '',
    'location': '',
    'name': '',
    'serviceDetail': '',
    'serviceType': '',
    'startDate': '',
    'status': '',
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
      if (projectInfoSnapshot['homeownerId'] == userId) {
        isHomeowner = true;
      }

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
          (projectInfoData['createdAt'] as Timestamp?)?.toDate().toString() ??
              '';
      _projectDetails['serviceType'] = projectDetailsData['serviceType'] ?? '';
      _projectDetails['serviceDetail'] =
          projectDetailsData['serviceDetail'] ?? '';
      _projectDetails['location'] = projectDetailsData['location'] ?? '';
      _projectDetails['startDate'] =
          (projectDetailsData['startDate'] as Timestamp?)
                  ?.toDate()
                  .toString() ??
              '';
      _projectDetails['name'] = projectDetailsData['name'] ?? 'Unnamed Project';
      _projectDetails['comments'] = projectDetailsData['comments'] ?? '';
      _projectDetails['endDate'] =
          (projectDetailsData['endDate'] as Timestamp?)?.toDate().toString() ??
              '';
      _projectDetails['budgetMin'] =
          (projectDetailsData['budgetMin'] as num?)?.toString() ?? '0';
      _projectDetails['budgetMax'] =
          (projectDetailsData['budgetMax'] as num?)?.toString() ?? '0';
      _projectDetails['comments'] = projectDetailsData['comments'] ?? '';
      _projectDetails['status'] = projectDetailsData['status'] ?? '';

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
                children: [
                  TitleBar(
                    projectHeader: _projectHeader,
                    onDecline: onDecline,
                    onAccept: onAccept,
                    isHomeowner: isHomeowner,
                  ),
                  ServiceRequestBody(
                    serviceRequest: _projectDetails,
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
    required this.isHomeowner,
  });

  final Map<String, String> projectHeader;
  final bool isHomeowner;
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
      padding: const EdgeInsets.only(left: 30, top: 84, bottom: 40, right: 30),
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
            DateFormat('dd/MM/yyyy HH:mm')
                .format(DateTime.parse(projectHeader['createdAt']!))
                .toString(),
            style: const TextStyle(
              color: Color(0xFF8F9193),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          if (!isHomeowner) const SizedBox(height: 30),
          if (!isHomeowner)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: DefaultSquareButton.onlyText(
                      context,
                      onPressed: onDecline,
                      text: 'Decline',
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DefaultSquareButton.onlyText(
                      context,
                      onPressed: onAccept,
                      text: 'Accept',
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ServiceRequestBody extends StatelessWidget {
  const ServiceRequestBody({super.key, required this.serviceRequest});

  final Map<String, String> serviceRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        top: 56,
        left: 30,
        right: 30,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: 'Project Name'),
          DisplayDetail(detail: serviceRequest['name'] ?? 'Unnamed Project'),
          const Separator(),
          const TitleSection(title: 'Service'),
          DisplayDetail(detail: serviceRequest['serviceType']!),
          const Separator(),
          const TitleSection(title: 'Service Detail'),
          DisplayDetail(detail: serviceRequest['serviceDetail']!),
          const Separator(),
          const TitleSection(title: 'Location'),
          DisplayDetail(detail: serviceRequest['location']!),
          const Separator(),
          const TitleSection(title: 'Timeline'),
          DisplayDetail(
            detail:
                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(serviceRequest['startDate']!))} - '
                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(serviceRequest['endDate']!))} ',
          ),
          const Separator(),
          const TitleSection(title: 'Budget'),
          DisplayDetail(
              detail:
                  'MYR ${serviceRequest['budgetMin']} - MYR ${serviceRequest['budgetMax']}'),
          const Separator(),
          const TitleSection(title: 'Additional Comments'),
          DisplayDetail(detail: serviceRequest['comments']!),
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Divider(
        color: Color(0xFF252525),
        height: 0,
        thickness: 1,
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.title,
    this.isRequired,
  });

  final String title;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title.toUpperCase() + (isRequired ?? false ? '*' : ''),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class DisplayDetail extends StatelessWidget {
  const DisplayDetail({super.key, required this.detail});

  final String detail;

  @override
  Widget build(BuildContext context) {
    return Text(
      detail,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: Color(0xFFB8B8B8),
      ),
    );
  }
}
