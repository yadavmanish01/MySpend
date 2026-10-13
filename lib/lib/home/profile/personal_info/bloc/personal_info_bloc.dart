import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firebase_storage_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/profile/personal_info/bloc/personal_info_event.dart';
import 'package:my_spend/lib/home/profile/personal_info/bloc/personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  PersonalInfoBloc() : super(const PersonalInfoState()) {
    on<LoadPersonalInfoEvent>(_onLoadPersonalInfo);
    on<ImagePickedEvent>(_onImagePicked);
    on<SavePersonalInfoSubmittedEvent>(_onSavePersonalInfoSubmitted);
  }

  Future<void> _onLoadPersonalInfo(
    LoadPersonalInfoEvent event,
    Emitter<PersonalInfoState> emit,
  ) async {
    final user = _authService.currentUser;
    if (user == null) return;

    emit(state.copyWith(
      status: Status.loading,
      name: user.displayName ?? user.email?.split('@').first ?? '',
      email: user.email ?? '',
    ));

    try {
      final doc = await _firestoreService.getUserProfile(user.uid);
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          emit(state.copyWith(
            status: Status.completed,
            name: data['name'] ?? state.name,
            photoUrl: data['photoUrl'],
          ));
          return;
        }
      }
      emit(state.copyWith(status: Status.completed));
    } catch (e) {
      emit(state.copyWith(status: Status.completed));
    }
  }

  void _onImagePicked(
    ImagePickedEvent event,
    Emitter<PersonalInfoState> emit,
  ) {
    emit(state.copyWith(imageFile: event.imageFile));
  }

  Future<void> _onSavePersonalInfoSubmitted(
    SavePersonalInfoSubmittedEvent event,
    Emitter<PersonalInfoState> emit,
  ) async {
    final user = _authService.currentUser;
    if (user == null) return;

    if (event.name.trim().isEmpty) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: 'Please enter a valid name',
      ));
      return;
    }

    emit(state.copyWith(postApiStatus: PostApiStatus.loading));

    try {
      String? uploadedUrl = state.photoUrl;
      if (state.imageFile != null) {
        uploadedUrl = await _storageService.uploadProfilePicture(
          uid: user.uid,
          imageFile: state.imageFile!,
        );
      }

      await _firestoreService.saveUserProfile(
        uid: user.uid,
        name: event.name.trim(),
        email: user.email ?? '',
        photoUrl: uploadedUrl,
      );

      emit(state.copyWith(
        postApiStatus: PostApiStatus.completed,
        name: event.name.trim(),
        photoUrl: uploadedUrl,
        message: 'Personal information saved successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.error,
        message: e.toString(),
      ));
    }
  }
}
