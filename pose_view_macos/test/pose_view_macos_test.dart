import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_macos/pose_view_macos.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PoseViewMacOS', () {
    const kPlatformName = 'MacOS';
    late PoseViewMacOS poseView;
    late List<MethodCall> log;

    setUp(() async {
      poseView = PoseViewMacOS();

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
      PoseViewMacOS.registerWith();
      expect(PoseViewPlatform.instance, isA<PoseViewMacOS>());
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
