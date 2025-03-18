import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/service_request_details.dart';

class ProjectDetailsPage extends StatelessWidget {
  final String projectId;
  final String status;
  final String contractor;
  final String date;
  final IconData icon;
  final Color iconColor;

  const ProjectDetailsPage({
    super.key,
    required this.projectId,
    required this.status,
    required this.contractor,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectHeader(),
            const SizedBox(height: 20),
            _buildStatusSection(),
            const SizedBox(height: 20),
            _buildRequestDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Project #$projectId',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Contractor ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                contractor,
                style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconColor,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status, style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Service Request', style: TextStyle(color: Colors.white, fontSize: 16)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServiceRequestDetailsPage()),
                );
              },
              child: const Text(
                'Preview >',
                style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Request on', style: TextStyle(color: Colors.white, fontSize: 16)),
            const Text('21/06/2024 21:38', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
