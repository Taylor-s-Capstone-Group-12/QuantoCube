import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/homeowner_homepage.dart';
import 'package:quantocube/page/Homeowner/project_details_page.dart';
import 'package:quantocube/page/Homeowner/request_approved_page.dart';
import 'package:quantocube/page/Homeowner/service_request_details.dart';
import 'package:quantocube/page/Homeowner/request_declined_page.dart';
import 'package:quantocube/page/Homeowner/quoted_page.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Project', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orange),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProjectCard(context, 'Service Requested', Icons.description, Colors.orange),
          _buildProjectCard(context, 'Request Approved', Icons.check_circle, Colors.orange, isApproved: true),
          _buildProjectCard(context, 'Request Declined', Icons.cancel, Colors.orange, isDeclined: true),
          _buildProjectCard(context, 'Quoted', Icons.attach_money, Colors.yellow, isQuoted: true),
          _buildProjectCard(context, 'Negotiate', Icons.monetization_on, Colors.yellow),
          _buildProjectCard(context, 'Quotation Updated', Icons.update, Colors.yellow),
          _buildProjectCard(context, 'Quotation Expired', Icons.timer_off, Colors.yellow),
          _buildProjectCard(context, 'Project Confirmed', Icons.thumb_up, Colors.yellow),
          _buildProjectCard(context, 'In Progress', Icons.work, Colors.blue),
          _buildProjectCard(context, 'In Progress (Request)', Icons.pending_actions, Colors.lightBlue),
          _buildProjectCard(context, 'Project Completed', Icons.check_box, Colors.green),
          _buildProjectCard(context, 'Project Closed', Icons.lock, Colors.teal),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildProjectCard(BuildContext context, String title, IconData icon, Color color, {bool isApproved = false, bool isDeclined = false, bool isQuoted = false}) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: const Text('22 Jun · Jackson Hon', style: TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: () {
          if (isApproved) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RequestApprovedPage()),
            );
          } else if (isDeclined) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RequestDeclinedPage()),
            );
          } else if (isQuoted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuotedPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailsPage(
                  projectId: '9876',
                  status: title,
                  contractor: 'Jackson Hon',
                  date: '22 Jun',
                  icon: icon,
                  iconColor: color,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeownerHomePage()),
            (route) => false,
          );
        } else if (index == 1) {
          Navigator.pushNamed(context, '/messages');
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectPage()),
          );
        } else if (index == 3) {
          Navigator.pushNamed(context, '/profile');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
