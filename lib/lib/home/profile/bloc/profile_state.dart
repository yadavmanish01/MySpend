import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool biometricEnabled;
  final String? message;

  const ProfileState({
    this.biometricEnabled = true,
    this.message,
  });

  ProfileState copyWith({
    bool? biometricEnabled,
    String? message,
  }) {
    return ProfileState(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [biometricEnabled, message];
}
