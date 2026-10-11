part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String name;
  final String email;
  final String password;
  final bool showPassword;
  final PostApiStatus postApiStatus;
  final String message;

  const SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.showPassword = true,
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    bool? showPassword,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [name, email, password, showPassword, postApiStatus, message];
}
