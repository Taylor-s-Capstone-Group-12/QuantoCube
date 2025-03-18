import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/service_request_details.dart';

class RequestDeclinedPage extends StatelessWidget {
  const RequestDeclinedPage({super.key});

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
            _buildStatusTimeline(),
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
          const Text(
            'Service Declined',
            style: TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Project #9876',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Contractor ', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const Text('Jackson Hon', style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusItem('Service Requested', Icons.description, Colors.grey, isCompleted: true),
        _buildStatusItem('Service Declined', Icons.description, Colors.orange, isCompleted: false),
      ],
    );
  }

  Widget _buildStatusItem(String title, IconData icon, Color color, {bool isCompleted = false}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isCompleted ? Colors.grey : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('22 Jun', style: TextStyle(color: Colors.grey, fontSize: 14)),
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
              child: const Text('Preview >', style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
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
