import 'dart:ui';

import '../point.dart';

abstract class SimpleMapProjection {
  ///
  /// This method converts the [point] coordinates
  /// to map offset representation.
  ///
  Offset project(SimpleMapPoint point, Size size);
}
