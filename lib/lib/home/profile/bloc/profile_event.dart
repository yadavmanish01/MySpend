import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ToggleBiometricEvent extends ProfileEvent {
  final bool enabled;
  const ToggleBiometricEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}
