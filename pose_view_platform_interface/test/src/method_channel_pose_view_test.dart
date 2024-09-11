import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_platform_interface/src/method_channel_pose_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelPoseView', () {
    late MethodChannelPoseView methodChannelPoseView;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelPoseView = MethodChannelPoseView();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelPoseView.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName = await methodChannelPoseView.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
