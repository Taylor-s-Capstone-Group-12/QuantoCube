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

  final Map<String, dynamic> _projectDetails = {
    'location': '',
    'details': '',
    'startDate': '',
    'endDate': '',
    'itemList': <Map<String, dynamic>>[],
    'subtotal': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
