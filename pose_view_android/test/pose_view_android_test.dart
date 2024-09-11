import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_android/pose_view_android.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PoseViewAndroid', () {
    const kPlatformName = 'Android';
    late PoseViewAndroid poseView;
    late List<MethodCall> log;

    setUp(() async {
      poseView = PoseViewAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(poseView.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      PoseViewAndroid.registerWith();
      expect(PoseViewPlatform.instance, isA<PoseViewAndroid>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await poseView.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
