import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pose_view_platform_interface/src/method_channel_pose_view.dart';

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

  static const EventChannel poseChannel =
      EventChannel('fit_worker/pose_data_stream');

  // Stream<dynamic> poseStream(PoseViewPlatform platform) {
  //   return poseChannel.receiveBroadcastStream();
  // }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  /// Returns the platform specific widget
  Widget getCameraPoseView();

  /// Returns the platform specific widget
  Widget getVideoPoseView(String videoPath);
}
