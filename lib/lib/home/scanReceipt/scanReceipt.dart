import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firebase_storage_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Scanreceipt extends StatefulWidget {
  const Scanreceipt({super.key});

  @override
  State<Scanreceipt> createState() => _ScanreceiptState();
}

class _ScanreceiptState extends State<Scanreceipt> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final FirestoreService _firestoreService = FirestoreService();

  File? _imageFile;
  bool _isProcessing = false;
  final String _merchantName = "Starbucks Coffee";
  final String _date = "10 Oct 2026";
  final String _category = "Food & Dining";
  final double _totalAmount = 450.0;
  String? _uploadedReceiptUrl;

  Future<void> _processReceipt(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
      _isProcessing = true;
    });

    try {
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        // Upload image to Firebase Storage
        _uploadedReceiptUrl = await _storageService.uploadReceiptImage(
          uid: uid,
          imageFile: _imageFile!,
        );

        // Auto Save Extracted Receipt to Firestore
        await _firestoreService.addTransaction(
          uid: uid,
          title: _merchantName,
          amount: _totalAmount,
          category: _category,
          isExpense: true,
          receiptUrl: _uploadedReceiptUrl,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Receipt Uploaded & Saved to Transactions!"),
              backgroundColor: AppColors.Success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error processing receipt: ${e.toString()}"),
            backgroundColor: AppColors.Error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
              Align(
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
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
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
              ),
              20.ph,
              // AI Extracted Details Preview Card
              Container(
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
                        Text(_merchantName, style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    6.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date:", style: AppTextStyles.caption),
                        Text(_date, style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    6.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Category:", style: AppTextStyles.caption),
                        Text(_category, style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    6.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount:", style: AppTextStyles.captionBold),
                        Text(
                          "₹${_totalAmount.toStringAsFixed(2)}",
                          style: AppTextStyles.headingLarge
                              .copyWith(color: AppColors.Success),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              25.ph,
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  prefixIcon: Icons.camera_alt_outlined,
                  width: MediaQuery.of(context).size.width * 0.7,
                  title: _isProcessing
                      ? "Uploading & Analyzing..."
                      : "Scan with Camera",
                  onPressed: _isProcessing
                      ? null
                      : () => _processReceipt(ImageSource.camera),
                ),
              ),
              15.ph,
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: _isProcessing
                      ? null
                      : () => _processReceipt(ImageSource.gallery),
                  child: Text(
                    "or choose from gallery",
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
