import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/lib/home/dashboard/bloc/dashboard_event.dart';
import 'package:my_spend/lib/home/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardTabChangedEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
