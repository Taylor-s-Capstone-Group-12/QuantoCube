import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/others/review_data.dart';

class ContractorPageArgs {
  final ContractorProfileData contractor;
  final List<ContractorReview> reviews;

  ContractorPageArgs({
    required this.contractor,
    required this.reviews,
  });
}

class RequestServiceArgs {
  final String contractorId;
  final String homeownerId;

  RequestServiceArgs({
    required this.contractorId,
    required this.homeownerId,
  });
}

class MessagePageArgs {
  final String projectId;
  final bool isFirstTime;

  MessagePageArgs({
    required this.projectId,
    this.isFirstTime = false,
  });
}
