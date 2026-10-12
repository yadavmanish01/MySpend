import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/homeview/bloc/home_event.dart';
import 'package:my_spend/lib/home/homeview/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<QuerySnapshot>? _transactionSubscription;

  HomeBloc() : super(const HomeState()) {
    on<FetchHomeDataEvent>(_onFetchHomeData);
    on<_UpdateHomeDataInternalEvent>(_onUpdateHomeDataInternal);
  }

  Future<void> _onFetchHomeData(
    FetchHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    final uid = _authService.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    emit(state.copyWith(status: Status.loading));

    await _transactionSubscription?.cancel();
    _transactionSubscription =
        _firestoreService.streamTransactions(uid).listen((snapshot) {
      double income = 0.0;
      double expenses = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final isExpense = data['isExpense'] as bool? ?? true;
        if (isExpense) {
          expenses += amount;
        } else {
          income += amount;
        }
      }

      add(_UpdateHomeDataInternalEvent(
        totalIncome: income,
        totalExpenses: expenses,
        totalBalance: income - expenses,
        transactions: snapshot.docs,
      ));
    });
  }

  void _onUpdateHomeDataInternal(
    _UpdateHomeDataInternalEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      status: Status.completed,
      totalIncome: event.totalIncome,
      totalExpenses: event.totalExpenses,
      totalBalance: event.totalBalance,
      transactions: event.transactions,
    ));
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}

class _UpdateHomeDataInternalEvent extends HomeEvent {
  final double totalIncome;
  final double totalExpenses;
  final double totalBalance;
  final List<QueryDocumentSnapshot> transactions;

  const _UpdateHomeDataInternalEvent({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalBalance,
    required this.transactions,
  });

  @override
  List<Object?> get props =>
      [totalIncome, totalExpenses, totalBalance, transactions];
}
