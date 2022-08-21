import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_map/simple_map.dart';

class MockCanvas extends Mock implements Canvas {}

void main() {
  final animation = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: const TestVSync(),
  );

  final options = SimpleMapOptions();

  test('test addPoint & clear', () {
    final controller = SimpleMapController();
    controller.addPoint(SimpleMapPoint(lat: 0, lng: 0));

    expect(controller.points?.length, 1);

    controller.clear();

    expect(controller.points?.length, 0);
  });

  test('test render', () async {
    final controller = SimpleMapController(points: [
      SimpleMapPoint(
        lat: 0,
        lng: 0,
        color: Color(0xFFFFFFFF),
      )
    ]);

    Canvas canvas = MockCanvas();
    Size size = Size(100, 100);

    controller.configure(options: options, animation: animation);

    controller.render(canvas, size);
    verify(canvas.drawCircle(Offset.zero, 0, Paint())).called(2);

    controller.addPoint(
      SimpleMapPoint(
        lat: 0,
        lng: 0,
        color: Color(0xFFFFFFFF),
        state: SimpleMapPointState.active,
      ),
    );

    controller.render(canvas, size);
    verify(canvas.drawCircle(Offset.zero, 0, Paint())).called(3);
  });
}
