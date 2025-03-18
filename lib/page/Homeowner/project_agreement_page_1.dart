import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/project_agreement_page_2.dart';

class ProjectAgreementPage extends StatelessWidget {
  const ProjectAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Page 1 of 2',
            style: TextStyle(color: Colors.orange, fontSize: 14)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildProjectDetails(),
            const SizedBox(height: 20),
            _buildScopeOfWork(),
            const SizedBox(height: 30),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROJECT AGREEMENT BETWEEN MARTINY ONG AND JACKSON HON',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Agreement Date         21/06/2024 21:38',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PROJECT DETAILS',
            style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(
          'The Homeowner has requested the following Services: Renovation and redesign of the living room to create a modern and cozy space. This includes new furniture, updated colour scheme, improved lighting, and overall aesthetic enhancement to match the client’s vision.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildScopeOfWork() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SCOPE OF WORK',
            style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(
          'Interior Design Consultation - Concept development for modern cozy design',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          'Painting Services - Application of new color scheme',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          'Furniture Package - Modern sofa, armchair, and coffee table',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectAgreementPage2()),
          );
        },
        child: const Text('Next Page >',
            style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
