import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

/// The Windows implementation of [PoseViewPlatform].
class PoseViewWindows extends PoseViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pose_view_windows');

  /// Registers this class as the default instance of [PoseViewPlatform]
  static void registerWith() {
    PoseViewPlatform.instance = PoseViewWindows();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

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
