part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent extends Equatable{}

class EmailChangedEvents extends SignupEvent{
  final String email;
  EmailChangedEvents({required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [email];
}

class PasswordChangeEvents extends SignupEvent{
  final String password;
  PasswordChangeEvents({required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [password];
}

class SignupApiEvents extends SignupEvent{
  SignupApiEvents();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
