import 'package:equatable/equatable.dart';

abstract class SavingGoalsEvent extends Equatable {
  const SavingGoalsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSavingGoalsEvent extends SavingGoalsEvent {
  const FetchSavingGoalsEvent();
}

class CreateSavingGoalEvent extends SavingGoalsEvent {
  final String title;
  final double targetAmount;

  const CreateSavingGoalEvent({
    required this.title,
    required this.targetAmount,
  });

  @override
  List<Object?> get props => [title, targetAmount];
}
