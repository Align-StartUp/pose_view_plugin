import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';
import 'package:pose_view_web/pose_view_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PoseViewWeb', () {
    const kPlatformName = 'Web';
    late PoseViewWeb poseView;

    setUp(() async {
      poseView = PoseViewWeb();
    });

    test('can be registered', () {
      PoseViewWeb.registerWith();
      expect(PoseViewPlatform.instance, isA<PoseViewWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await poseView.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
