import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pose_view/pose_view.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

class MockPoseViewPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PoseViewPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PoseView', () {
    late PoseViewPlatform poseViewPlatform;

    setUp(() {
      poseViewPlatform = MockPoseViewPlatform();
      PoseViewPlatform.instance = poseViewPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => poseViewPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => poseViewPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
