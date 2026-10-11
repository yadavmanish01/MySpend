import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/lib/auth/login/login_events.dart';
import 'package:my_spend/lib/auth/login/login_states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  LoginBloc() : super(const LoginState()) {
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<PasswordVisibilityEvents>(_passwordvisibility);
  }

  void _onEmailChanged(
    EmailChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _passwordvisibility(PasswordVisibilityEvents events, Emitter<LoginState>emit){
    emit(state.copyWith(showPassword:!state.showPassword));
  }


  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (state.email.trim().isEmpty) {
      emit(
        state.copyWith(
          postApiStatus: PostApiStatus.error,
          message: 'Please enter your email',
        ),
      );
      return;
    }

    if (state.password.trim().isEmpty) {
      emit(
        state.copyWith(
          postApiStatus: PostApiStatus.error,
          message: 'Please enter your password',
        ),
      );
      return;
    }

    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      await _authService.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      emit(
        state.copyWith(
          postApiStatus: PostApiStatus.completed,
          message: 'Login successful!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          postApiStatus: PostApiStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
