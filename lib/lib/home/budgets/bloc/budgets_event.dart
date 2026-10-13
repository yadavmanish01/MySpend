import 'package:equatable/equatable.dart';

abstract class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object?> get props => [];
}

class FetchBudgetsEvent extends BudgetsEvent {
  const FetchBudgetsEvent();
}

class CreateBudgetEvent extends BudgetsEvent {
  final String category;
  final double limitAmount;

  const CreateBudgetEvent({
    required this.category,
    required this.limitAmount,
  });

  @override
  List<Object?> get props => [category, limitAmount];
}
