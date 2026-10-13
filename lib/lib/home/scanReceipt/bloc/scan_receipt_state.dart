import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';

class ScanReceiptState extends Equatable {
  final File? imageFile;
  final String merchantName;
  final String date;
  final String category;
  final double totalAmount;
  final PostApiStatus postApiStatus;
  final String message;

  const ScanReceiptState({
    this.imageFile,
    this.merchantName = 'Starbucks Coffee',
    this.date = '10 Oct 2026',
    this.category = 'Food & Dining',
    this.totalAmount = 450.0,
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  ScanReceiptState copyWith({
    File? imageFile,
    String? merchantName,
    String? date,
    String? category,
    double? totalAmount,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return ScanReceiptState(
      imageFile: imageFile ?? this.imageFile,
      merchantName: merchantName ?? this.merchantName,
      date: date ?? this.date,
      category: category ?? this.category,
      totalAmount: totalAmount ?? this.totalAmount,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        imageFile,
        merchantName,
        date,
        category,
        totalAmount,
        postApiStatus,
        message
      ];
}
