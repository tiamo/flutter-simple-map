import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_map/simple_map.dart';

class MockCanvas extends Mock implements Canvas {
  @override
  void drawCircle(Offset? c, double? radius, Paint? paint) {
    super.noSuchMethod(Invocation.method(#drawCircle, [c, radius, paint]));
  }
}

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
    final controller = SimpleMapController(
      points: [
        SimpleMapPoint(
          lat: 0,
          lng: 0,
          color: Color(0xFFFFFFFF),
        )
      ],
    );

    final canvas = MockCanvas();
    final size = Size.square(100);

    controller.configure(
      options: options,
      animation: animation,
    );

    controller.render(canvas, size);
    verify(canvas.drawCircle(any, any, any)).called(2);

    controller.addPoint(
      SimpleMapPoint(
        lat: 0,
        lng: 0,
        color: Color(0xFFFFFFFF),
        state: SimpleMapPointState.active,
      ),
    );

    controller.render(canvas, size);
    verify(canvas.drawCircle(any, any, any)).called(3);
  });
}
