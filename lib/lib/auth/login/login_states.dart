import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final PostApiStatus postApiStatus;
  final String message;
  final bool showPassword;

  const LoginState({
    this.email = '',
    this.password = '',
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
    this.showPassword= true
  });

  LoginState copyWith({
    String? email,
    String? password,
    PostApiStatus? postApiStatus,
    String? message,
    bool? showPassword
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
      showPassword: showPassword??this.showPassword
    );
  }

  @override
  List<Object?> get props => [email, password, postApiStatus, message,showPassword];
}
