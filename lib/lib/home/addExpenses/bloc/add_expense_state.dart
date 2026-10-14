import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_spend/data/response/postApiStatus.dart';

class AddExpenseState extends Equatable {
  final String amount;
  final String category;
  final String notes;
  final bool isExpense;
  final List<Map<String, dynamic>> categories;
  final PostApiStatus postApiStatus;
  final String message;

  const AddExpenseState({
    this.amount = '',
    this.category = '',
    this.notes = '',
    this.isExpense = true,
    this.categories = const [
      {"name": "Food", "amount": "₹8,240", "icon": Icons.fastfood_rounded},
      {"name": "Travel", "amount": "₹4,580", "icon": Icons.directions_car_rounded},
      {"name": "Bills", "amount": "₹5,000", "icon": Icons.receipt_long_rounded},
      {"name": "Shopping", "amount": "₹3,800", "icon": Icons.shopping_bag_rounded},
      {"name": "Health", "amount": "₹1,920", "icon": Icons.medical_services_rounded},
      {"name": "Other", "amount": "₹880", "icon": Icons.more_horiz_rounded},
    ],
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  AddExpenseState copyWith({
    String? amount,
    String? category,
    String? notes,
    bool? isExpense,
    List<Map<String, dynamic>>? categories,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return AddExpenseState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isExpense: isExpense ?? this.isExpense,
      categories: categories ?? this.categories,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [amount, category, notes, isExpense, categories, postApiStatus, message];
}
