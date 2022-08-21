# Flutter Simple Map

A Flutter plugin, which displays a simple flat world map with animated dots, useful for real time data representation.
Can be used as a presentation of online users, devices, etc.

[![Build Status](https://github.com/tiamo/flutter-simple-map/actions/workflows/ci.yml/badge.svg)](https://github.com/tiamo/flutter-simple-map)
[![Pub package](https://img.shields.io/pub/v/simple_map.svg)](https://pub.dartlang.org/packages/simple_map)
[![Star on GitHub](https://img.shields.io/github/stars/tiamo/flutter-simple-map.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/tiamo/flutter-simple-map)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

<img src="https://github.com/tiamo/flutter-simple-map/raw/main/screens/1.gif" width="200"><img src="https://github.com/tiamo/flutter-simple-map/raw/main/screens/2.gif" width="200"><img src="https://github.com/tiamo/flutter-simple-map/raw/main/screens/3.gif" width="200"><img src="https://github.com/tiamo/flutter-simple-map/raw/main/screens/4.gif" width="200">

## Getting Started

* Add this to your pubspec.yaml
  ```
  dependencies:
  simple_map: ^1.0.0
  ```
* Get the package from Pub:
  ```
  flutter packages get
  ```
* Import it in your file
  ```
  import 'package:simple_map/simple_map.dart';
  ```

## Features

* Good performance with lot of data
* Render simple customizable flat map
* Render points with animation effect
* Customize every point
* Create points with TTL
* Custom point animations
* Marker support
* Zoom and Move animations

## Usage

* Using SimpleMapOptions
```dart
final mapOptions = SimpleMapOptions(
    // Custom map icon with projection
    // mapIcon: IconData(0xe900, fontFamily: 'MapIcons'),
    // projection: ...
  
    mapColor: Colors.grey,
    bgColor: Colors.black,
    // Default point color
    pointColor: Colors.blue,
    
    interactive: true,
    
    // 3d effect
    withShadow: true,
    shadowOffset = const Offset(0.0, 0.5),
);
```

* Using SimpleMapController
```dart
final SimpleMapController mapController = SimpleMapController();

// Add single point.
mapController.addPoint(SimpleMapPoint());

// Add list of points
mapController.points = [SimpleMapPoint()];

// Clear the map.
mapController.clear();

SimpleMap(
  controller: mapController,
  options: mapOptions,
),
```

* Simple map with one center point with duration of 100 seconds
```dart
SimpleMap(
  controller: SimpleMapController(points: [
    SimpleMapPoint(
      lat: 0.0,
      lng: 0.0,
      color: Colors.blue,
      ttl: Duration(seconds: 100),
    )
  ]),
  options: mapOptions,
),
```

Check out the complete [Example](https://github.com/tiamo/flutter-simple-map/tree/master/example)

## Changelog

Please have a look in [CHANGELOG](CHANGELOG.md)

## Maintainers
 
* [Vlad Korniienko](https://github.com/tiamo)
 
## License

[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
