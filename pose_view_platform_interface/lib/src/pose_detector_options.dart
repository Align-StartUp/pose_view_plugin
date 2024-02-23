// ignore_for_file: public_member_api_docs

enum PoseDetectionModel {
  lite,
  full,
  heavy,
}

enum PoseDetectionMode {
  stream,
}

class PoseDetectorOptions {
  PoseDetectorOptions({
    this.model = PoseDetectionModel.full,
    this.mode = PoseDetectionMode.stream,
    this.minPoseDetectionConfidence = 0.5,
    this.minPoseTrackingConfidence = 0.5,
    this.minPosePresenceConfidence = 0.5,
  });

  final PoseDetectionModel model;
  final PoseDetectionMode mode;
  final double minPoseDetectionConfidence;
  final double minPoseTrackingConfidence;
  final double minPosePresenceConfidence;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'model': model.index,
      'mode': mode.index,
      'minPoseDetectionConfidence': minPoseDetectionConfidence,
      'minPoseTrackingConfidence': minPoseTrackingConfidence,
      'minPosePresenceConfidence': minPosePresenceConfidence,
    };
  }
}
