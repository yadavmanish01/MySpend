import 'package:equatable/equatable.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AmountChangedEvent extends AddExpenseEvent {
  final String amount;
  const AmountChangedEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class CategoryChangedEvent extends AddExpenseEvent {
  final String category;
  const CategoryChangedEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class NotesChangedEvent extends AddExpenseEvent {
  final String notes;
  const NotesChangedEvent(this.notes);

  @override
  List<Object?> get props => [notes];
}

class TransactionTypeChangedEvent extends AddExpenseEvent {
  final bool isExpense;
  const TransactionTypeChangedEvent(this.isExpense);

  @override
  List<Object?> get props => [isExpense];
}

class SaveExpenseSubmittedEvent extends AddExpenseEvent {
  const SaveExpenseSubmittedEvent();
}
