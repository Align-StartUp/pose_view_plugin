// ignore_for_file: public_member_api_docs

enum PoseDetectionModel {
  lite,
  full,
  heavy,
}

// ignore: constant_identifier_names
enum PoseDetectionDelegate { CPU, GPU }

class PoseDetectorOptions {
  PoseDetectorOptions({
    this.model = PoseDetectionModel.full,
    this.delegate = PoseDetectionDelegate.CPU,
    this.minPoseDetectionConfidence = 0.5,
    this.minPoseTrackingConfidence = 0.5,
    this.minPosePresenceConfidence = 0.5,
  });

  final PoseDetectionModel model;
  final PoseDetectionDelegate delegate;
  final double minPoseDetectionConfidence;
  final double minPoseTrackingConfidence;
  final double minPosePresenceConfidence;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'model': model.index,
      'delegate': delegate.index,
      'minPoseDetectionConfidence': minPoseDetectionConfidence,
      'minPoseTrackingConfidence': minPoseTrackingConfidence,
      'minPosePresenceConfidence': minPosePresenceConfidence,
    };
  }
}
