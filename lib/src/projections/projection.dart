import 'package:flutter/widgets.dart';

abstract class SimpleMapProjection {
  ///
  /// This method converts the [lat] and [lng] coordinates
  /// to map offset representation.
  ///
  Offset project(double? lat, double? lng, Size? size);
}
