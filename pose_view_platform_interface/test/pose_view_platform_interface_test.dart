import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

class PoseViewMock extends PoseViewPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;

  @override
  Widget getCameraPoseView() {
    // TODO: implement getCameraPoseView
    throw UnimplementedError();
  }

  @override
  Widget getVideoPoseView(String videoPath) {
    // TODO: implement getVideoPoseView
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PoseViewPlatformInterface', () {
    late PoseViewPlatform poseViewPlatform;

    setUp(() {
      poseViewPlatform = PoseViewMock();
      PoseViewPlatform.instance = poseViewPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await PoseViewPlatform.instance.getPlatformName(),
          equals(PoseViewMock.mockPlatformName),
        );
      });
    });
  });
}
