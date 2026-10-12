import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/addExpenses/bloc/add_expense_event.dart';
import 'package:my_spend/lib/home/addExpenses/bloc/add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  AddExpenseBloc() : super(const AddExpenseState()) {
    on<AmountChangedEvent>(_onAmountChanged);
    on<CategoryChangedEvent>(_onCategoryChanged);
    on<NotesChangedEvent>(_onNotesChanged);
    on<TransactionTypeChangedEvent>(_onTransactionTypeChanged);
    on<SaveExpenseSubmittedEvent>(_onSaveExpenseSubmitted);
  }

  void _onAmountChanged(
      AmountChangedEvent event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onCategoryChanged(
      CategoryChangedEvent event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onNotesChanged(
      NotesChangedEvent event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  void _onTransactionTypeChanged(
      TransactionTypeChangedEvent event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(isExpense: event.isExpense));
  }

  Future<void> _onSaveExpenseSubmitted(
      SaveExpenseSubmittedEvent event, Emitter<AddExpenseState> emit) async {
    final parsedAmount =
        double.tryParse(state.amount.replaceAll('₹', '').replaceAll(',', '').trim()) ?? 0.0;

    if (parsedAmount <= 0) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: 'Please enter a valid amount',
      ));
      return;
    }

    final category =
        state.category.trim().isEmpty ? 'General' : state.category.trim();
    final title =
        state.notes.trim().isEmpty ? category : state.notes.trim();
    final uid = _authService.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: 'User not logged in',
      ));
      return;
    }

    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      await _firestoreService.addTransaction(
        uid: uid,
        title: title,
        amount: parsedAmount,
        category: category,
        isExpense: state.isExpense,
      );

      emit(state.copyWith(
        postApiStatus: PostApiStatus.completed,
        message: 'Transaction saved successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: e.toString(),
      ));
    }
  }
}
