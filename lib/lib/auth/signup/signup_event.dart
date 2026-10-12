part of 'signup_bloc.dart';


abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class NameChangedEvent extends SignupEvent {
  final String name;
  const NameChangedEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class EmailChangedEvent extends SignupEvent {
  final String email;
  const EmailChangedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordChangedEvent extends SignupEvent {
  final String password;
  const PasswordChangedEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

class PasswordVisibilityEvent extends SignupEvent {
  const PasswordVisibilityEvent();

  @override
  List<Object?> get props => [];
}

class SignupSubmittedEvent extends SignupEvent {
  const SignupSubmittedEvent();

  @override
  List<Object?> get props => [];
}
