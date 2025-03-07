import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:top_up_ticket/core/router/router.dart';
import 'package:top_up_ticket/features/mobile_recharge/view/cubit/mobile_recharge_cubit.dart';
import 'package:top_up_ticket/features/mobile_recharge/view/cubit/mobile_recharge_state.dart';
import 'package:top_up_ticket/shared/view/widgets/add_beneficiary_form.dart';
import 'package:top_up_ticket/features/mobile_recharge/view/widgets/mobile_recharge_header.dart';
import 'package:top_up_ticket/features/mobile_recharge/view/widgets/mobile_recharge_section.dart';
import 'package:top_up_ticket/shared/domain/repositories/beneficiary_repository.dart';
import 'package:top_up_ticket/shared/domain/repositories/user_repository.dart';

import '../../../../core/router/screen_name.dart';

class RechargeScreen extends StatelessWidget {
  const RechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MobileRechargeCubit(
        userRepository: context.read<UserRepository>(),
        beneficiaryRepository: context.read<BeneficiaryRepository>(),
      )..loadData(),
      child: const _RechargeScreenContent(),
    );
  }
}

class _RechargeScreenContent extends StatelessWidget {
  const _RechargeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBeneficiaryDialog(
            context,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<MobileRechargeCubit, MobileRechargeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            networkError: () => const Center(
              child: Text(
                  'No Internet Connection. Please check your connection and try again.'),
            ),
            generalError: () => const Center(
              child: Text('Something went wrong. Please try again later.'),
            ),
            success: (user, beneficiaries) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    MobileRechargeHeader(userName: user.name),
                    const SizedBox(height: 50),
                    MobileRechargeSection(
                      beneficiaries: beneficiaries,
                      onRechargeNow: (beneficiary) {
                        context.goNamed(
                          ScreenNames.topup,
                          extra: TopUpScreenExtraArgs(
                            beneficiary: beneficiary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showAddBeneficiaryDialog(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const AddBeneficiaryForm(),
        ),
      ),
    );
  }
}
