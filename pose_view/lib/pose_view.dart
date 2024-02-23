import 'package:flutter/widgets.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

PoseViewPlatform get _platform => PoseViewPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}

/// Returns a stream of pose data.
Stream<dynamic> poseStream() {
  return PoseViewPlatform.poseChannel.receiveBroadcastStream();
}

/// Provides a platform-specific view.
class CameraPoseView extends StatelessWidget {
  /// Creates a new [CameraPoseView] widget.
  const CameraPoseView({super.key});

  @override
  Widget build(BuildContext context) {
    return _platform.getCameraPoseView();
  }
}

/// Provides a platform-specific view.
/// Input video_url is a string of the video url.
class VideoPoseView extends StatelessWidget {
  /// Creates a new [VideoPoseView] widget.
  const VideoPoseView({required this.videoPath, super.key});

  /// The url of the video.
  final String videoPath;

  @override
  Widget build(BuildContext context) {
    return _platform.getVideoPoseView(videoPath);
  }
}
