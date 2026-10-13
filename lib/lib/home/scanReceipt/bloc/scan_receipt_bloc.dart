import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firebase_storage_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_event.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_state.dart';
import 'package:my_spend/services/receipt_scanner_service.dart';

class ScanReceiptBloc extends Bloc<ScanReceiptEvent, ScanReceiptState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final FirestoreService _firestoreService = FirestoreService();
  final ReceiptScannerService _scannerService = ReceiptScannerService();

  ScanReceiptBloc() : super(const ScanReceiptState()) {
    on<ProcessReceiptImageEvent>(_onProcessReceiptImage);
  }

  Future<void> _onProcessReceiptImage(
    ProcessReceiptImageEvent event,
    Emitter<ScanReceiptState> emit,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: event.source);
    if (picked == null) return;

    final imageFile = File(picked.path);
    emit(state.copyWith(
      imageFile: imageFile,
      postApiStatus: PostApiStatus.loading,
    ));

    try {
      // 1. Scan image with AI / OCR service
      final scannedData = await _scannerService.scanReceipt(imageFile);

      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        // 2. Upload image to Firebase Storage if available
        String? receiptUrl;
        try {
          receiptUrl = await _storageService.uploadReceiptImage(
            uid: uid,
            imageFile: imageFile,
          );
        } catch (_) {
          // If storage fail, proceed gracefully with transaction creation
        }

        // 3. Save extracted details directly to Firestore
        await _firestoreService.addTransaction(
          uid: uid,
          title: scannedData.merchant,
          amount: scannedData.amount,
          category: scannedData.category,
          isExpense: true,
          receiptUrl: receiptUrl,
        );

        emit(state.copyWith(
          merchantName: scannedData.merchant,
          totalAmount: scannedData.amount,
          category: scannedData.category,
          date: scannedData.date,
          postApiStatus: PostApiStatus.completed,
          message: 'Receipt scanned & saved successfully!',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: e.toString(),
      ));
    }
  }
}
