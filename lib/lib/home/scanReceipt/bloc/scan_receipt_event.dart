import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ScanReceiptEvent extends Equatable {
  const ScanReceiptEvent();

  @override
  List<Object?> get props => [];
}

class ProcessReceiptImageEvent extends ScanReceiptEvent {
  final ImageSource source;
  const ProcessReceiptImageEvent(this.source);

  @override
  List<Object?> get props => [source];
}
