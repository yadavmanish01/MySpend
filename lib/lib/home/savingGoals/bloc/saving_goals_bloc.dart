import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/savingGoals/bloc/saving_goals_event.dart';
import 'package:my_spend/lib/home/savingGoals/bloc/saving_goals_state.dart';

class SavingGoalsBloc extends Bloc<SavingGoalsEvent, SavingGoalsState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<QuerySnapshot>? _goalsSubscription;

  SavingGoalsBloc() : super(const SavingGoalsState()) {
    on<FetchSavingGoalsEvent>(_onFetchSavingGoals);
    on<CreateSavingGoalEvent>(_onCreateSavingGoal);
    on<_UpdateSavingGoalsInternalEvent>(_onUpdateSavingGoalsInternal);
  }

  Future<void> _onFetchSavingGoals(
    FetchSavingGoalsEvent event,
    Emitter<SavingGoalsState> emit,
  ) async {
    final uid = _authService.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    emit(state.copyWith(status: Status.loading));

    await _goalsSubscription?.cancel();
    _goalsSubscription =
        _firestoreService.streamSavingGoals(uid).listen((snapshot) {
      add(_UpdateSavingGoalsInternalEvent(snapshot.docs));
    });
  }

  void _onUpdateSavingGoalsInternal(
    _UpdateSavingGoalsInternalEvent event,
    Emitter<SavingGoalsState> emit,
  ) {
    emit(state.copyWith(
      status: Status.completed,
      goals: event.goals,
    ));
  }

  Future<void> _onCreateSavingGoal(
    CreateSavingGoalEvent event,
    Emitter<SavingGoalsState> emit,
  ) async {
    final uid = _authService.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      await _firestoreService.addSavingGoal(
        uid: uid,
        title: event.title,
        targetAmount: event.targetAmount,
      );

      emit(state.copyWith(
        postApiStatus: PostApiStatus.completed,
        message: 'Saving goal created successfully!',
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
    _goalsSubscription?.cancel();
    return super.close();
  }
}

class _UpdateSavingGoalsInternalEvent extends SavingGoalsEvent {
  final List<QueryDocumentSnapshot> goals;
  const _UpdateSavingGoalsInternalEvent(this.goals);

  @override
  List<Object?> get props => [goals];
}
