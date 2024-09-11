import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pose_view_platform_interface/src/method_channel_pose_view.dart';
import 'package:pose_view_platform_interface/src/one_euro_filter.dart';
import 'package:pose_view_platform_interface/src/pose_detector_options.dart';
import 'package:pose_view_platform_interface/src/pose_landmarker.dart';

export 'package:pose_view_platform_interface/src/pose_detector_options.dart';
export 'package:pose_view_platform_interface/src/pose_landmarker.dart';

/// The interface that implementations of pose_view must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `PoseView`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [PoseViewPlatform] methods.
abstract class PoseViewPlatform extends PlatformInterface {
  /// Constructs a PoseViewPlatform.
  PoseViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static PoseViewPlatform _instance = MethodChannelPoseView();

  /// The default instance of [PoseViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelPoseView].
  static PoseViewPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PoseViewPlatform] when they register themselves.
  static set instance(PoseViewPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  /// Returns the platform specific widget
  Widget getCameraPoseView(PoseDetectorOptions options);

  /// Returns the platform specific widget
  Widget getVideoPoseView(String videoPath, PoseDetectorOptions options);

  /// Event channel used to receive pose data.
  final poseChannel = const EventChannel('fit_worker/pose_data_stream');

  static final _logger = Logger('PoseViewPlatform');

  /// Returns a stream of pose data.
  Stream<PoseData> receivePoseStream() {
    return poseChannel.receiveBroadcastStream().map((event) {
      // First, ensure the event is a Map.
      if (event is Map) {
        final poseData = PoseData.fromMap(event);
        _logger.info('${poseData.toJson()}');
        return poseData;
      } else {
        throw Exception('Invalid event type: ${event.runtimeType}');
      }
    });
  }
}

class PoseViewController {
  /// Constructor for PoseViewController.
  /// [smoothLandmarks] is an optional parameter that defaults to false.
  PoseViewController({this.smoothLandmarks = false});
  final PoseViewPlatform _platform = PoseViewPlatform.instance;

  bool smoothLandmarks;

  /// Returns a stream of pose data.
  Stream<PoseData> receivePoseStream() {
    if (smoothLandmarks) {
      return _platform.receivePoseStream().map(OneEuroFilterStrategy().filter);
    }

    return _platform.receivePoseStream();
  }
}
