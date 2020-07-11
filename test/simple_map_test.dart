import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_map/simple_map.dart';

void main() {
  SimpleMapOptions options = SimpleMapOptions();
  SimpleMapController controller = SimpleMapController(
    points: [
      SimpleMapPoint(lat: 0, lng: 0),
    ],
  );

  testWidgets('SimpleMap basic usage', (WidgetTester tester) async {
    final mapKey = Key('simple_map');

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: SimpleMap(
          key: mapKey,
          controller: controller,
          options: options,
        ),
      ),
    );

    expect(find.byKey(mapKey), findsOneWidget);
  });
}
