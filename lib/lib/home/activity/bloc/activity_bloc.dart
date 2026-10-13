import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/activity/bloc/activity_event.dart';
import 'package:my_spend/lib/home/activity/bloc/activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<QuerySnapshot>? _transactionSubscription;

  ActivityBloc() : super(const ActivityState()) {
    on<FetchActivityEvent>(_onFetchActivity);
    on<FilterChangedEvent>(_onFilterChanged);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<_UpdateActivityInternalEvent>(_onUpdateActivityInternal);
  }

  Future<void> _onFetchActivity(
    FetchActivityEvent event,
    Emitter<ActivityState> emit,
  ) async {
    final uid = _authService.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    emit(state.copyWith(status: Status.loading));

    await _transactionSubscription?.cancel();
    _transactionSubscription =
        _firestoreService.streamTransactions(uid).listen((snapshot) {
      add(_UpdateActivityInternalEvent(snapshot.docs));
    });
  }

  void _onFilterChanged(
    FilterChangedEvent event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(selectedFilterIndex: event.filterIndex));
  }

  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onUpdateActivityInternal(
    _UpdateActivityInternalEvent event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(
      status: Status.completed,
      transactions: event.transactions,
    ));
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}

class _UpdateActivityInternalEvent extends ActivityEvent {
  final List<QueryDocumentSnapshot> transactions;
  const _UpdateActivityInternalEvent(this.transactions);

  @override
  List<Object?> get props => [transactions];
}
