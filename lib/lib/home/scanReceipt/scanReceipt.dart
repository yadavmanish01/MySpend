import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_bloc.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_event.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_state.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Scanreceipt extends StatelessWidget {
  const Scanreceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanReceiptBloc(),
      child: const _ScanReceiptContent(),
    );
  }
}

class _ScanReceiptContent extends StatelessWidget {
  const _ScanReceiptContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<ScanReceiptBloc, ScanReceiptState>(
          listenWhen: (previous, current) =>
              previous.postApiStatus != current.postApiStatus,
          listener: (context, state) {
            if (state.postApiStatus == PostApiStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.Error,
                ),
              );
            } else if (state.postApiStatus == PostApiStatus.completed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.Success,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.ph,
                Text("Scan Receipt", style: AppTextStyles.headingLarge),
                20.ph,
                Text("Capture your receipt", style: AppTextStyles.headingLarge),
                Text(
                  "We'll extract amount, date and merchant automatically.",
                  style: AppTextStyles.captionBold,
                ),
                15.ph,
                BlocBuilder<ScanReceiptBloc, ScanReceiptState>(
                  builder: (context, state) {
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: state.imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(state.imageFile!, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    size: 50,
                                    color: AppColors.primary,
                                  ),
                                  10.ph,
                                  Text(
                                    "Align Receipt Inside Frame",
                                    style: AppTextStyles.captionBold,
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                20.ph,
                // AI Extracted Details Preview Card
                BlocBuilder<ScanReceiptBloc, ScanReceiptState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: Colors.amber, size: 20),
                              8.pw,
                              Text(
                                "AI Extracted Details Preview",
                                style: AppTextStyles.captionBold.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          12.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Merchant:", style: AppTextStyles.caption),
                              Text(state.merchantName, style: AppTextStyles.bodyLarge),
                            ],
                          ),
                          6.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date:", style: AppTextStyles.caption),
                              Text(state.date, style: AppTextStyles.bodyLarge),
                            ],
                          ),
                          6.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Category:", style: AppTextStyles.caption),
                              Text(state.category, style: AppTextStyles.bodyLarge),
                            ],
                          ),
                          6.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Amount:", style: AppTextStyles.captionBold),
                              Text(
                                "₹${state.totalAmount.toStringAsFixed(2)}",
                                style: AppTextStyles.headingLarge
                                    .copyWith(color: AppColors.Success),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                25.ph,
                BlocBuilder<ScanReceiptBloc, ScanReceiptState>(
                  buildWhen: (previous, current) =>
                      previous.postApiStatus != current.postApiStatus,
                  builder: (context, state) {
                    final isLoading =
                        state.postApiStatus == PostApiStatus.loading;
                    return Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        prefixIcon: Icons.camera_alt_outlined,
                        width: MediaQuery.of(context).size.width * 0.7,
                        title: isLoading
                            ? "Uploading & Analyzing..."
                            : "Scan with Camera",
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<ScanReceiptBloc>().add(
                                      const ProcessReceiptImageEvent(
                                          ImageSource.camera),
                                    );
                              },
                      ),
                    );
                  },
                ),
                15.ph,
                BlocBuilder<ScanReceiptBloc, ScanReceiptState>(
                  buildWhen: (previous, current) =>
                      previous.postApiStatus != current.postApiStatus,
                  builder: (context, state) {
                    final isLoading =
                        state.postApiStatus == PostApiStatus.loading;
                    return Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<ScanReceiptBloc>().add(
                                      const ProcessReceiptImageEvent(
                                          ImageSource.gallery),
                                    );
                              },
                        child: Text(
                          "or choose from gallery",
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
