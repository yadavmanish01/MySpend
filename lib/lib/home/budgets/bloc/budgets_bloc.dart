import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/budgets/bloc/budgets_event.dart';
import 'package:my_spend/lib/home/budgets/bloc/budgets_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<QuerySnapshot>? _budgetSubscription;

  BudgetsBloc() : super(const BudgetsState()) {
    on<FetchBudgetsEvent>(_onFetchBudgets);
    on<CreateBudgetEvent>(_onCreateBudget);
    on<_UpdateBudgetsInternalEvent>(_onUpdateBudgetsInternal);
  }

  Future<void> _onFetchBudgets(
    FetchBudgetsEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    final uid = _authService.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    emit(state.copyWith(status: Status.loading));

    await _budgetSubscription?.cancel();
    _budgetSubscription =
        _firestoreService.streamBudgets(uid).listen((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['limitAmount'] as num?)?.toDouble() ?? 0.0;
      }

      add(_UpdateBudgetsInternalEvent(
        budgets: snapshot.docs,
        totalLimit: total,
      ));
    });
  }

  void _onUpdateBudgetsInternal(
    _UpdateBudgetsInternalEvent event,
    Emitter<BudgetsState> emit,
  ) {
    emit(state.copyWith(
      status: Status.completed,
      budgets: event.budgets,
      totalLimit: event.totalLimit,
    ));
  }

  Future<void> _onCreateBudget(
    CreateBudgetEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    final uid = _authService.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      await _firestoreService.setBudget(
        uid: uid,
        category: event.category,
        limitAmount: event.limitAmount,
      );

      emit(state.copyWith(
        postApiStatus: PostApiStatus.completed,
        message: 'Budget saved successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _budgetSubscription?.cancel();
    return super.close();
  }
}

class _UpdateBudgetsInternalEvent extends BudgetsEvent {
  final List<QueryDocumentSnapshot> budgets;
  final double totalLimit;

  const _UpdateBudgetsInternalEvent({
    required this.budgets,
    required this.totalLimit,
  });

  @override
  List<Object?> get props => [budgets, totalLimit];
}
