import 'package:flutter/widgets.dart';

const _ff = 'MapProjection';
const _fp = 'simple_map';

///
/// Default map projection icons
///
class MapProjectionIcon {
  const MapProjectionIcon._();
  static const miller = IconData(0xe900, fontFamily: _ff, fontPackage: _fp);
  static const mercator = IconData(0xe901, fontFamily: _ff, fontPackage: _fp);
}
