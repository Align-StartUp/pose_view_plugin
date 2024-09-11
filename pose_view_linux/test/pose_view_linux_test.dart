import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_linux/pose_view_linux.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PoseViewLinux', () {
    const kPlatformName = 'Linux';
    late PoseViewLinux poseView;
    late List<MethodCall> log;

    setUp(() async {
      poseView = PoseViewLinux();

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
      PoseViewLinux.registerWith();
      expect(PoseViewPlatform.instance, isA<PoseViewLinux>());
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
