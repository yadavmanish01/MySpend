import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';

class AddExpenseState extends Equatable {
  final String amount;
  final String category;
  final String notes;
  final bool isExpense;
  final PostApiStatus postApiStatus;
  final String message;

  const AddExpenseState({
    this.amount = '',
    this.category = '',
    this.notes = '',
    this.isExpense = true,
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  AddExpenseState copyWith({
    String? amount,
    String? category,
    String? notes,
    bool? isExpense,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return AddExpenseState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isExpense: isExpense ?? this.isExpense,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [amount, category, notes, isExpense, postApiStatus, message];
}
