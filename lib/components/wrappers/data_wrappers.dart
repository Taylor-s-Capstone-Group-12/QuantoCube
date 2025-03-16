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
