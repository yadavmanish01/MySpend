import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/status.dart';

class HomeState extends Equatable {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final List<QueryDocumentSnapshot> transactions;
  final Status status;
  final String message;

  const HomeState({
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.transactions = const [],
    this.status = Status.initial,
    this.message = '',
  });

  HomeState copyWith({
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
    List<QueryDocumentSnapshot>? transactions,
    Status? status,
    String? message,
  }) {
    return HomeState(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [totalBalance, totalIncome, totalExpenses, transactions, status, message];
}
