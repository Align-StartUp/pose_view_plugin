import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

/// The iOS implementation of [PoseViewPlatform].
class PoseViewIOS extends PoseViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pose_view_ios');

  /// Registers this class as the default instance of [PoseViewPlatform]
  static void registerWith() {
    PoseViewPlatform.instance = PoseViewIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getCameraPoseView(PoseDetectorOptions options) {
    const viewType = '@views/camera-pose-view';

    /// Creation parameters for the camera pose view.
    final creationParams = <String, dynamic>{
      'options': options.toJson(),
    };

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          EagerGestureRecognizer.new,
        ),
      },
    );
  }

  @override
  Widget getVideoPoseView(String videoPath, PoseDetectorOptions options) {
    const viewType = '@views/video-pose-view';

    /// Creation parameters for the video pose view.
    final creationParams = <String, dynamic>{
      'videoPath': videoPath,
      'options': options.toJson(),
    };

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          EagerGestureRecognizer.new,
        ),
      },
    );
  }
}
