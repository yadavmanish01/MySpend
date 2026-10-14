import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/lib/onboarding/bloc/onboarding_event.dart';
import 'package:my_spend/lib/onboarding/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChangedEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.pageIndex));
    });
  }
}
