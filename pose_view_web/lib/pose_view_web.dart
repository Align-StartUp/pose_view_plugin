import 'package:flutter/src/widgets/framework.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

/// The Web implementation of [PoseViewPlatform].
class PoseViewWeb extends PoseViewPlatform {
  /// Registers this class as the default instance of [PoseViewPlatform]
  static void registerWith([Object? registrar]) {
    PoseViewPlatform.instance = PoseViewWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';

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
