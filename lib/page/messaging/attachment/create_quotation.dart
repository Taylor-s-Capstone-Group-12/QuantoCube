import 'package:flutter/material.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/overlays/loading_overlay.dart';
import 'package:quantocube/theme.dart';

class CreateQuotationPage extends StatefulWidget {
  const CreateQuotationPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<CreateQuotationPage> createState() => _CreateQuotationPageState();
}

class _CreateQuotationPageState extends State<CreateQuotationPage> {
  final GlobalKey<LoadingOverlayState> _loadingOverlayKey =
      GlobalKey<LoadingOverlayState>();
  final Map<String, dynamic> quotationDetails = {};
  bool isValid = false;

  void onContinue() {
    // Send quotation details to the server
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      key: _loadingOverlayKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TitleBar(),
              QuotationBody(
                quotationDetails: quotationDetails,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Stack(children: [
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[900],
            ),
            LargeOrangeButton.onlyText(
              context,
              onPressed: isValid ? onContinue : null,
              text: 'Send Request',
            ),
          ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 30, top: 84),
      margin: const EdgeInsets.only(bottom: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
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
          const SizedBox(width: 7),
          const Text(
            'New Quote',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class QuotationBody extends StatefulWidget {
  const QuotationBody({super.key, required this.quotationDetails});

  final Map<String, dynamic> quotationDetails;

  @override
  State<QuotationBody> createState() => _QuotationBodyState();
}

class _QuotationBodyState extends State<QuotationBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
        ),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.only(
        top: 56,
        left: 30,
        right: 30,
        bottom: 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: 'Project Name', isRequired: true),
          TextInputBox(
            maxLines: 1,
            hintText: 'Enter project name',
          ),
          const Separator(),
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
        title + (isRequired ?? false ? '*' : ''),
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

class TextInputBox extends StatelessWidget {
  const TextInputBox({
    super.key,
    required this.hintText,
    this.maxLines = 5,
  });

  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: ProjectTheme.inputDecoration(context).copyWith(
        hintText: hintText,
      ),
    );
  }
}
