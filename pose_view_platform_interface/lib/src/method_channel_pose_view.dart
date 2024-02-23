import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

/// An implementation of [PoseViewPlatform] that uses method channels.
class MethodChannelPoseView extends PoseViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pose_view');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getCameraPoseView() {
    return const SizedBox();
  }

  @override
  Widget getVideoPoseView(String videoPath) {
    return const SizedBox();
  }
}
