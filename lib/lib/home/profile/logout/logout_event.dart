part of 'logout_bloc.dart';

abstract class LogoutEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LogoutButtonPressed extends LogoutEvent{
  LogoutButtonPressed();
}