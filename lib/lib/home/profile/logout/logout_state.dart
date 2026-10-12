part of 'logout_bloc.dart';

class LogoutState extends Equatable {
  final String message;
  final PostApiStatus postApiStatus;
  const LogoutState({
    this.message = '',
    this.postApiStatus = PostApiStatus.initial,
  });

  LogoutState copyWith({String? message, PostApiStatus? postApiStatus}) {
    return LogoutState(
      message: message ?? this.message,
      postApiStatus: postApiStatus ?? this.postApiStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [message,postApiStatus];
}
