# Online World Map

A Flutter plugin for displaying a flat world map with realtime animated points. 
Can be used as presentation of online users.

[![Build Status](https://travis-ci.org/tiamo/flutter-online-world-map.svg?branch=master)](https://travis-ci.org/tiamo/flutter-online-world-map)
[![Pub package](https://img.shields.io/pub/v/online_world_map.svg)](https://pub.dartlang.org/packages/online_world_map)
[![Star on GitHub](https://img.shields.io/github/stars/tiamo/flutter-online-world-map.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/tiamo/flutter-online-world-map)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

## Getting Started

* Add this to your pubspec.yaml
  ```
  dependencies:
  online_world_map: ^0.0.1
  ```
* Get the package from Pub:
  ```
  flutter packages get
  ```
* Import it in your file
  ```
  import 'package:online_world_map/online_world_map.dart';
  ```

## Features

* Render simple customizable flat map
* Render points with animation effect
* Customize every point
* Create points with TTL
* Good performance with lot of data

## TODO

* Think about StreamController
* Render optimization

## Usage

* Using OWMapOptions
```dart
final mapOptions = OWMapOptions(
    mapColor: Colors.grey,
    bgColor: Colors.black,
);
```

* Simple map with one point
```dart
OWMap(
  controller: OWMapController(points: [
    OWMapPoint(
      lat: 0.0,
      lng: 0.0,
      color: Colors.blue,
      ttl: Duration(seconds: 100),
    )
  ]),
  options: mapOptions,
),
```

* Using OWMapController
```dart
final OWMapController mapController = OWMapController();

// Add single point.
mapController.addPoint(OWMapPoint());

// Add list of points
mapController.points = [OWMapPoint()];

// Clear the map.
mapController.clear();

OWMap(
  controller: mapController,
  options: mapOptions,
),
```

* Check out the complete [Example](https://github.com/tiamo/flutter-online-world-map/tree/master/example)

## Maintainers
 
* [Vlad Korniienko](https://github.com/tiamo)
 
## License

[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)