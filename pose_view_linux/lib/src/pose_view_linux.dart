import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

/// The Linux implementation of [PoseViewPlatform].
class PoseViewLinux extends PoseViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pose_view_linux');

  /// Registers this class as the default instance of [PoseViewPlatform]
  static void registerWith() {
    PoseViewPlatform.instance = PoseViewLinux();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getCameraPoseView() {
    // TODO: implement getCameraPoseView(
    throw UnimplementedError();
  }

  @override
  Widget getVideoPoseView(String videoPath) {
    // TODO: implement getVideoPoseView
    throw UnimplementedError();
  }
}
