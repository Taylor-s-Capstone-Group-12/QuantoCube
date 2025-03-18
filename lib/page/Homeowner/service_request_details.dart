import 'package:flutter/material.dart';

class ServiceRequestDetailsPage extends StatelessWidget {
  const ServiceRequestDetailsPage({super.key});

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
        title: const Text('Service Request', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSection('SERVICE', 'Interior Design'),
            _buildSection('SERVICE DETAIL',
                'I am looking to renovate my living room and seeking a modern and cozy design. And, I would like to incorporate a new colour scheme and furniture.'),
            _buildFileAttachment('IMG_7559.PNG'),
            _buildSection('LOCATION', 'Sky Greenfield Condominium, Bukit Jalil'),
            _buildSection('TIMELINE', '15/07/2024 - 31/08/2024 (1.5 Months)'),
            _buildSection('BUDGET', 'MYR 5,000 - MYR 10,000'),
            _buildSection('ADDITIONAL COMMENTS',
                'Open to any suggestions and ideas you may have to enhance our space.'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '#12345',
            style: TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Service Request',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Created', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text('21/06/2024 21:38', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contractor', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Row(
                    children: [
                      const Text('Jackson Hon', style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFileAttachment(String fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.attachment, color: Colors.orange),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(fileName, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
