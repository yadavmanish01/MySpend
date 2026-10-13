import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firebase_storage_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_event.dart';
import 'package:my_spend/lib/home/scanReceipt/bloc/scan_receipt_state.dart';

class ScanReceiptBloc extends Bloc<ScanReceiptEvent, ScanReceiptState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final FirestoreService _firestoreService = FirestoreService();

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
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        final receiptUrl = await _storageService.uploadReceiptImage(
          uid: uid,
          imageFile: imageFile,
        );

        await _firestoreService.addTransaction(
          uid: uid,
          title: state.merchantName,
          amount: state.totalAmount,
          category: state.category,
          isExpense: true,
          receiptUrl: receiptUrl,
        );

        emit(state.copyWith(
          postApiStatus: PostApiStatus.completed,
          message: 'Receipt uploaded & saved to transactions!',
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
