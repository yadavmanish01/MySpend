import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
  /// Creates a [SizedBox] with this value as width.
  SizedBox get width => SizedBox(width: toDouble());
  /// Shorthand for height [SizedBox]
  SizedBox get ph => SizedBox(height: toDouble());
  /// Shorthand for width [SizedBox]
  SizedBox get pw => SizedBox(width: toDouble());
}
