// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// Available pose landmarks
enum PoseLandmarkType {
  nose,
  leftEyeInner,
  leftEye,
  leftEyeOuter,
  rightEyeInner,
  rightEye,
  rightEyeOuter,
  leftEar,
  rightEar,
  leftMouth,
  rightMouth,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPinky,
  rightPinky,
  leftIndex,
  rightIndex,
  leftThumb,
  rightThumb,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftHeel,
  rightHeel,
  leftFootIndex,
  rightFootIndex
}

/// Describes a pose detection result.
class Pose {
  /// Constructor to create an instance of [Pose].
  Pose({required this.landmarks, required this.worldLandmarks});

  factory Pose.fromMap(Map<String, dynamic> data) {
    if (data
        case {
          'landmarks': final List<Map<String, dynamic>> landmarksData,
          'worldLandmarks': final List<Map<String, dynamic>> worldLandmarksData,
        }) {
      return Pose(
        landmarks: Map<PoseLandmarkType, PoseLandmark>.fromIterables(
          PoseLandmarkType.values,
          landmarksData.map(
            (landmarkMap) => PoseLandmark.fromMap(
              landmarkMap,
              PoseLandmarkType.values[landmarksData.indexOf(landmarkMap)],
            ),
          ),
        ),
        worldLandmarks: Map<PoseLandmarkType, PoseLandmark>.fromIterables(
          PoseLandmarkType.values,
          worldLandmarksData.map(
            (landmarkMap) => PoseLandmark.fromMap(
              landmarkMap,
              PoseLandmarkType.values[worldLandmarksData.indexOf(landmarkMap)],
            ),
          ),
        ),
      );
    } else {
      throw FormatException('Invalid pose data: $data');
    }
  }

  final Map<PoseLandmarkType, PoseLandmark> landmarks;

  final Map<PoseLandmarkType, PoseLandmark> worldLandmarks;

  bool allPoseLandmarksAreInFrame() {
    return landmarks.values.every(
      (element) =>
          element.x >= 0 && element.x <= 1 && element.y >= 0 && element.y <= 1,
    );
  }
}

/// A landmark in a pose detection result.
class PoseLandmark {
  /// Constructor to create an instance of [PoseLandmark].
  PoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
    required this.presence,
  });

  /// Returns an instance of [PoseLandmark] from a given map.
  factory PoseLandmark.fromMap(
    Map<String, dynamic> data,
    PoseLandmarkType landmarkType,
  ) {
    if (data
        case {
          'x': final double x,
          'y': final double y,
          'z': final double z,
          'visibility': final double visibility,
          'presence': final double presence,
        }) {
      return PoseLandmark(
        type: landmarkType,
        x: x,
        y: y,
        z: z,
        visibility: visibility,
        presence: presence,
      );
    } else {
      throw FormatException('Invalid landmark data: $data');
    }
  }

  /// The landmark type.
  final PoseLandmarkType type;

  /// Gives x coordinate of landmark in image frame.
  final double x;

  /// Gives y coordinate of landmark in image frame.
  final double y;

  /// Gives z coordinate of landmark in image space.
  final double z;

  final double visibility;
  final double presence;
}

class PoseData {
  PoseData(this.pose, this.inputImageSize);

  factory PoseData.fromMap(Map<String, dynamic> data) {
    if (data
        case {
          'poseResult': final Map<String, dynamic> pose,
          'inputImageHeight': final double height,
          'inputImageWidth': final double width,
        }) {
      return PoseData(
        Pose.fromMap(pose),
        Size(
          width,
          height,
        ),
      );
    } else {
      throw FormatException('Invalid pose data: $data');
    }
  }

  final Pose pose;
  final Size inputImageSize;
}
