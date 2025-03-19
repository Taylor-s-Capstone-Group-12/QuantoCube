import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/overlays/loading_overlay.dart';

class QuotationReviewPage extends StatefulWidget {
  const QuotationReviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<QuotationReviewPage> createState() => _QuotationReviewPageState();
}

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class _QuotationReviewPageState extends State<QuotationReviewPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<LoadingOverlayState> _overlayKey =
      GlobalKey<LoadingOverlayState>();
  bool isLoading = true;
  bool isHomeowner = false;

  final Map<String, String> _projectHeader = {
    'title': 'Quotation',
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
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
