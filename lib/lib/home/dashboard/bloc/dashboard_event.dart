import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardTabChangedEvent extends DashboardEvent {
  final int index;
  const DashboardTabChangedEvent(this.index);

  @override
  List<Object?> get props => [index];
}
