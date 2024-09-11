import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

double smoothing_factor(
  double elapsedTime,
  double cutoff,
) {
  final r = 2.0 * 3.14 * cutoff * elapsedTime;
  return r / (r + 1.0);
}

double exponential_smoothing(
  double value,
  double prev,
  double alpha,
) {
  return alpha * value + (1.0 - alpha) * prev;
}

class OneEuroFilter {
  OneEuroFilter({
    this.minCutoff = 2.0,
    this.beta = 0.0,
    this.dCutoff = 1.0,
  });

  double minCutoff;
  double beta;
  double dCutoff;
  double xPrev = 0;
  double dxPrev = 0;
  DateTime lastTime = DateTime.now();

  double filter(double x) {
    final now = DateTime.now();
    final elapsedTime = now.difference(lastTime).inMilliseconds / 1000.0;

    if (elapsedTime <= 0.0001) {
      xPrev = x;
      return x;
    }

    lastTime = now;

    // The filtered derivative of the signal.
    final alphaD = smoothing_factor(elapsedTime, dCutoff);
    final dx = (x - xPrev) / elapsedTime;
    final dxHat = exponential_smoothing(dx, dxPrev, alphaD);

    // The filtered signal.
    final cutoff = minCutoff + beta * dxHat.abs();
    final alpha = smoothing_factor(elapsedTime, cutoff);
    final xHat = exponential_smoothing(x, xPrev, alpha);

    xPrev = xHat;
    dxPrev = dxHat;

    return xHat;
  }
}

abstract class PoseDataFilter {
  PoseData filter(PoseData poseData);
}

class OneEuroFilterStrategy implements PoseDataFilter {
  Map<PoseLandmarkType, Map<String, OneEuroFilter>> worldFilters = {};
  Map<PoseLandmarkType, Map<String, OneEuroFilter>> landmarkFilters = {};

  @override
  PoseData filter(PoseData poseData) {
    poseData.pose.worldLandmarks.forEach((type, landmark) {
      // Ensure each landmark type has its own set of filters
      worldFilters[type] ??= {
        'x': OneEuroFilter(),
        'y': OneEuroFilter(),
        'z': OneEuroFilter(),
      };

      final filteredX = worldFilters[type]!['x']!.filter(landmark.x);
      final filteredY = worldFilters[type]!['y']!.filter(landmark.y);
      final filteredZ = worldFilters[type]!['z']!.filter(landmark.z);

      // Update the landmark coordinates directly
      landmark.updateCoordinates(filteredX, filteredY, filteredZ);
    });

    poseData.pose.landmarks.forEach((type, landmark) {
      // Ensure each landmark type has its own set of filters
      landmarkFilters[type] ??= {
        'x': OneEuroFilter(),
        'y': OneEuroFilter(),
        'z': OneEuroFilter(),
      };

      final filteredX = landmarkFilters[type]!['x']!.filter(landmark.x);
      final filteredY = landmarkFilters[type]!['y']!.filter(landmark.y);
      final filteredZ = landmarkFilters[type]!['z']!.filter(landmark.z);

      // Update the landmark coordinates directly
      landmark.updateCoordinates(filteredX, filteredY, filteredZ);
    });

    // Since updates are in-place, just return the modified poseData
    return poseData;
  }
}
