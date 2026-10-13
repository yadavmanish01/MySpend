import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/status.dart';

class ActivityState extends Equatable {
  final List<QueryDocumentSnapshot> transactions;
  final int selectedFilterIndex;
  final String searchQuery;
  final Status status;
  final String message;

  const ActivityState({
    this.transactions = const [],
    this.selectedFilterIndex = 0,
    this.searchQuery = '',
    this.status = Status.initial,
    this.message = '',
  });

  ActivityState copyWith({
    List<QueryDocumentSnapshot>? transactions,
    int? selectedFilterIndex,
    String? searchQuery,
    Status? status,
    String? message,
  }) {
    return ActivityState(
      transactions: transactions ?? this.transactions,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [transactions, selectedFilterIndex, searchQuery, status, message];
}
