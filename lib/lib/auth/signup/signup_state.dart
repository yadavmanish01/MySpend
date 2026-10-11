part of 'signup_bloc.dart';

class SignupState extends Equatable{
  final String email;
  final String password;
  final PostApiStatus postApiStatus;
  const SignupState({this.email='',this.password='',
  this.postApiStatus=PostApiStatus.initial});

  SignupState copyWith({String? email,
  String? password}){return SignupState(email: email??this.email,
  password: password??this.password);}


  @override
  // TODO: implement props
  List<Object?> get props =>[email,password];

}


