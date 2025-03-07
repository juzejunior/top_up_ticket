import 'package:flutter/material.dart';
import 'package:top_up_ticket/features/mobile_recharge/view/widgets/beneficiary_card.dart';
import 'package:top_up_ticket/shared/domain/entities/beneficiary.dart';

class MobileRechargeSection extends StatefulWidget {
  const MobileRechargeSection({
    super.key,
    required this.beneficiaries,
    this.onRechargeNow,
  });

  final List<Beneficiary> beneficiaries;
  final Function(
    Beneficiary beneficiary,
  )? onRechargeNow;

  @override
  State<MobileRechargeSection> createState() => _MobileRechargeSectionState();
}

class _MobileRechargeSectionState extends State<MobileRechargeSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabbar = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabbar = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Recharge',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 24,
        ),
        MobileRechargeTabBar(
          tabController: _tabController,
        ),
        const SizedBox(
          height: 24,
        ),
        Builder(
          builder: (context) {
            if (_selectedTabbar == 0) {
              return _BeneficiariesList(
                beneficiaries: widget.beneficiaries,
                onRechargeNow: widget.onRechargeNow,
              );
            } else {
              return _RechargeHistory();
            }
          },
        ),
      ],
    );
  }
}

class _BeneficiariesList extends StatelessWidget {
  const _BeneficiariesList({
    required this.beneficiaries,
    this.onRechargeNow,
  });

  final List<Beneficiary> beneficiaries;
  final Function(
    Beneficiary beneficiary,
  )? onRechargeNow;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (beneficiaries.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Text(
              "You have no beneficiaries. Add one on '+' button.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      final screenWidth = MediaQuery.of(context).size.width;
      final cardWidth = screenWidth * 0.35;

      return SizedBox(
        height: cardWidth,
        child: ListView.builder(
          itemCount: beneficiaries.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 20.0),
          itemBuilder: (context, index) {
            final beneficiary = beneficiaries[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: cardWidth,
                child: BeneficiaryCard(
                  name: beneficiary.nickName,
                  phoneNumber: beneficiary.phoneNumber,
                  onTap: () {
                    onRechargeNow?.call(beneficiary);
                  },
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _RechargeHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Text(
          'Here you will see the history of your recharges. Coming soon!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MobileRechargeTabBar extends StatelessWidget {
  const MobileRechargeTabBar({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(
          text: 'Recharge',
        ),
        Tab(
          text: 'History',
        ),
      ],
    );
  }
}
