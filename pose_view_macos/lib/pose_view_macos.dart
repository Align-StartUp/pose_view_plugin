import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

/// The MacOS implementation of [PoseViewPlatform].
class PoseViewMacOS extends PoseViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pose_view_macos');

  /// Registers this class as the default instance of [PoseViewPlatform]
  static void registerWith() {
    PoseViewPlatform.instance = PoseViewMacOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getCameraPoseView(PoseDetectorOptions options) {
    // TODO: implement getCameraPoseView
    throw UnimplementedError();
  }

  @override
  Widget getVideoPoseView(String videoPath, PoseDetectorOptions options) {
    // TODO: implement getVideoPoseView
    throw UnimplementedError();
  }
}
