import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/status.dart';

class NotificationState extends Equatable {
  final List<Map<String, dynamic>> notifications;
  final Status status;
  final String message;

  const NotificationState({
    this.notifications = const [],
    this.status = Status.initial,
    this.message = '',
  });

  NotificationState copyWith({
    List<Map<String, dynamic>>? notifications,
    Status? status,
    String? message,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [notifications, status, message];
}
