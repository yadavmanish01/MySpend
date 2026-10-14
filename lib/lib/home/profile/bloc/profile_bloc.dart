import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/lib/home/profile/bloc/profile_event.dart';
import 'package:my_spend/lib/home/profile/bloc/profile_state.dart';
import 'package:my_spend/services/local_auth_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LocalAuthService _authService = LocalAuthService();

  ProfileBloc() : super(const ProfileState()) {
    on<ToggleBiometricEvent>(_onToggleBiometric);
  }

  Future<void> _onToggleBiometric(
    ToggleBiometricEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.enabled) {
      final authenticated = await _authService.authenticate();
      if (authenticated) {
        emit(state.copyWith(
          biometricEnabled: true,
          message: "Biometric Lock Enabled Successfully!",
        ));
      } else {
        emit(state.copyWith(
          biometricEnabled: false,
          message: "Biometric Authentication Failed",
        ));
      }
    } else {
      emit(state.copyWith(
        biometricEnabled: false,
        message: "Biometric Lock Disabled",
      ));
    }
  }
}
