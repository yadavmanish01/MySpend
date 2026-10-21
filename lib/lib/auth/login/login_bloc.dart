import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_analytics_service.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/auth/login/login_events.dart';
import 'package:my_spend/lib/auth/login/login_states.dart';
import 'package:my_spend/services/localStorage.dart';
import 'package:my_spend/services/sessionController.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  LoginBloc() : super(const LoginState()) {
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<GoogleSignInSubmittedEvent>(_onGoogleSignInSubmitted);
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

  Future<void> _onGoogleSignInSubmitted(
    GoogleSignInSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      final credential = await _authService.continueWithGoogle();

      if (credential != null && credential.user != null) {
        final uid = credential.user!.uid;
        final email = credential.user!.email;
        final displayName = credential.user!.displayName;
        final photoUrl = credential.user!.photoURL;

        // Ensure user is created in Firestore 
        await _firestoreService.saveUserProfile(
          uid: uid,
          name: displayName ?? email?.split('@').first ?? 'User',
          email: email ?? '',
          photoUrl: photoUrl,
        );

        await LocalStorage().saveAuthToken(uid);
        await SessionController().saveUserInPreference({
          'uid': uid,
          'email': email ?? '',
        });

        await FirebaseAnalyticsService().logLogin(loginMethod: 'google');

        emit(state.copyWith(
          postApiStatus: PostApiStatus.completed,
          message: 'Google login successful!',
        ));
      } else {
        emit(state.copyWith(
          postApiStatus: PostApiStatus.error,
          message: 'Google Sign In was cancelled or failed.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: e.toString(),
      ));
    }
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
      final credential = await _authService.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      final uid = credential.user?.uid;
      final email = credential.user?.email;
      if (uid != null) {
        await LocalStorage().saveAuthToken(uid);
        await SessionController().saveUserInPreference({
          'uid': uid,
          'email': email ?? '',
        });
      }

      await FirebaseAnalyticsService().logLogin(loginMethod: 'email');

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
