import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';

class PersonalInfoState extends Equatable {
  final String name;
  final String email;
  final String? photoUrl;
  final File? imageFile;
  final Status status;
  final PostApiStatus postApiStatus;
  final String message;

  const PersonalInfoState({
    this.name = '',
    this.email = '',
    this.photoUrl,
    this.imageFile,
    this.status = Status.initial,
    this.postApiStatus = PostApiStatus.initial,
    this.message = '',
  });

  PersonalInfoState copyWith({
    String? name,
    String? email,
    String? photoUrl,
    File? imageFile,
    Status? status,
    PostApiStatus? postApiStatus,
    String? message,
  }) {
    return PersonalInfoState(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      imageFile: imageFile ?? this.imageFile,
      status: status ?? this.status,
      postApiStatus: postApiStatus ?? this.postApiStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [name, email, photoUrl, imageFile, status, postApiStatus, message];
}
