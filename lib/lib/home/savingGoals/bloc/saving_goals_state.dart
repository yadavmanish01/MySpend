import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';

class SavingGoalsState extends Equatable {
  final List<QueryDocumentSnapshot> goals;
  final Status status;
  final PostApiStatus postApiStatus;
  final String message;

  const SavingGoalsState({
    this.goals = const [],
    this.status = Status.initial,
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  SavingGoalsState copyWith({
    List<QueryDocumentSnapshot>? goals,
    Status? status,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return SavingGoalsState(
      goals: goals ?? this.goals,
      status: status ?? this.status,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [goals, status, postApiStatus, message];
}
