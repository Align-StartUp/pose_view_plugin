import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';
import 'package:pose_view_windows/pose_view_windows.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PoseViewWindows', () {
    const kPlatformName = 'Windows';
    late PoseViewWindows poseView;
    late List<MethodCall> log;

    setUp(() async {
      poseView = PoseViewWindows();

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
      PoseViewWindows.registerWith();
      expect(PoseViewPlatform.instance, isA<PoseViewWindows>());
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
