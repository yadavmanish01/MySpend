import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/lib/notification/bloc/notification_event.dart';
import 'package:my_spend/lib/notification/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
  }

  void _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(status: Status.loading));

    final sampleNotifications = [
      {
        "title": "Budget Exceeded Alert",
        "description": "You have spent 85% of your monthly Food budget.",
        "time": "2 hours ago",
        "icon": "alert",
      },
      {
        "title": "Daily Expense Reminder",
        "description": "Don't forget to log today's transactions!",
        "time": "1 day ago",
        "icon": "reminder",
      },
      {
        "title": "Saving Goal Milestone",
        "description": "Congratulations! You reached 64% of Emergency Fund.",
        "time": "3 days ago",
        "icon": "goal",
      },
    ];

    emit(state.copyWith(
      status: Status.completed,
      notifications: sampleNotifications,
    ));
  }
}
