import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/services/localStorage.dart';
import 'package:my_spend/services/sessionController.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  LogoutBloc() : super(const LogoutState()) {
    on<LogoutButtonPressed>(_logoutApi);
  }

  Future<void> _logoutApi(
    LogoutButtonPressed event,
    Emitter<LogoutState> emit,
  ) async {
    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      await _authService.signOut();
      await LocalStorage().clearAuthToken();
      await SessionController().clearSession();

      emit(state.copyWith(
        postApiStatus: PostApiStatus.completed,
        message: 'Logged out successfully',
      ));
    } catch (error) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: error.toString(),
      ));
    }
  }
}
