import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PersonalInfoEvent extends Equatable {
  const PersonalInfoEvent();

  @override
  List<Object?> get props => [];
}

class LoadPersonalInfoEvent extends PersonalInfoEvent {
  const LoadPersonalInfoEvent();
}

class ImagePickedEvent extends PersonalInfoEvent {
  final File imageFile;
  const ImagePickedEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class SavePersonalInfoSubmittedEvent extends PersonalInfoEvent {
  final String name;
  const SavePersonalInfoSubmittedEvent({required this.name});

  @override
  List<Object?> get props => [name];
}
