import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';

class BudgetsState extends Equatable {
  final List<QueryDocumentSnapshot> budgets;
  final double totalLimit;
  final Status status;
  final PostApiStatus postApiStatus;
  final String message;

  const BudgetsState({
    this.budgets = const [],
    this.totalLimit = 0.0,
    this.status = Status.initial,
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  BudgetsState copyWith({
    List<QueryDocumentSnapshot>? budgets,
    double? totalLimit,
    Status? status,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return BudgetsState(
      budgets: budgets ?? this.budgets,
      totalLimit: totalLimit ?? this.totalLimit,
      status: status ?? this.status,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [budgets, totalLimit, status, postApiStatus, message];
}
