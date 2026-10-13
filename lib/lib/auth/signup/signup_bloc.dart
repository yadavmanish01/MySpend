import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_analytics_service.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/services/localStorage.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  SignupBloc() : super(const SignupState()) {
    on<NameChangedEvent>(_onNameChanged);
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<PasswordVisibilityEvent>(_onPasswordVisibility);
    on<SignupSubmittedEvent>(_onSignupSubmitted);
  }

  void _onNameChanged(NameChangedEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onEmailChanged(EmailChangedEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChangedEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onPasswordVisibility(PasswordVisibilityEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  Future<void> _onSignupSubmitted(SignupSubmittedEvent event, Emitter<SignupState> emit) async {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(postApiStatus: PostApiStatus.error, message: 'Please enter your name'));
      return;
    }
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(postApiStatus: PostApiStatus.error, message: 'Please enter your email'));
      return;
    }
    if (state.password.trim().isEmpty || state.password.length < 6) {
      emit(state.copyWith(postApiStatus: PostApiStatus.error, message: 'Password must be at least 6 characters'));
      return;
    }

    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      final credential = await _authService.signUpWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        await _firestoreService.saveUserProfile(
          uid: uid,
          name: state.name.trim(),
          email: state.email.trim(),
        );
        await LocalStorage().saveAuthToken(uid);
      }

      await FirebaseAnalyticsService().logSignUp(signUpMethod: 'email');

      emit(state.copyWith(postApiStatus: PostApiStatus.completed, message: 'Account created successfully!'));
    } catch (e) {
      emit(state.copyWith(postApiStatus: PostApiStatus.error, message: e.toString()));
    }
  }
}
