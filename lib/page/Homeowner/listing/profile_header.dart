import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.contractor});

  final ContractorProfileData contractor;

  void onClickMessage() {
    // TODO: Implement message button
    print('Message button clicked');
  }

  void onClickMoreOptions() {
    // TODO: Implement more options button
    print('More options button clicked');
  }

  void onClickHire() {
    // TODO: Implement hire button
    print('Hire button clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 94.0, left: 30.0, right: 30.0),
      child: Column(
        children: [
          TopHeader(
            onClickMessage: onClickMessage,
            onClickMoreOptions: onClickMoreOptions,
            imgUrl: contractor.profileImage ?? '',
          ),
          const SizedBox(height: 16),
          Text(
            contractor.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ContractorStats(contractor: contractor),
          const SizedBox(height: 30),
          SizedBox(
            width: 147,
            child: DefaultSquareButton.onlyText(
              context,
              onPressed: onClickHire,
              text: 'Hire',
              fontSize: 15,
              height: 45,
            ),
          ),
        ],
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({
    super.key,
    required this.onClickMessage,
    required this.onClickMoreOptions,
    required this.imgUrl,
  });

  final VoidCallback onClickMessage;
  final VoidCallback onClickMoreOptions;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: CircularBackButton(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CircularProfilePicture(imageUrl: imgUrl),
          ),
          Align(
            alignment: Alignment.topRight,
            child: OptionButtons(
              onClickMessage: onClickMessage,
              onClickMoreOptions: onClickMoreOptions,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButtons extends StatelessWidget {
  const OptionButtons({
    super.key,
    required this.onClickMessage,
    required this.onClickMoreOptions,
  });

  final VoidCallback onClickMessage;
  final VoidCallback onClickMoreOptions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onClickMessage,
          icon: const Icon(
            Icons.chat,
            color: Colors.white,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: onClickMoreOptions,
          icon: const Icon(
            Icons.more_horiz,
            color: Colors.white,
            size: 25,
          ),
        ),
      ],
    );
  }
}

class ContractorStats extends StatelessWidget {
  const ContractorStats({
    super.key,
    required this.contractor,
  });

  final ContractorProfileData contractor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatBox(
          value: contractor.appriciation.toString(),
          icon: Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
        ),
        const StatBoxSeperator(),
        StatBox(
          value: contractor.rating.toString(),
          icon: const Icon(
            Icons.star,
            color: Color(0xFFEEBE41),
            size: 20,
          ),
        ),
      ],
    );
  }
}

class StatBoxSeperator extends StatelessWidget {
  const StatBoxSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 5, left: 7),
      child: Text(
        '·',
        style: TextStyle(
          color: Color(0xFF8F9193),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  const StatBox({
    super.key,
    required this.value,
    required this.icon,
  });

  final String value;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
