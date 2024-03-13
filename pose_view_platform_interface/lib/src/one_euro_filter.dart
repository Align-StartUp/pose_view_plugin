import 'dart:math';

import 'package:pose_view_platform_interface/pose_view_platform_interface.dart';

double smoothing_factor(
  double elapsed_time,
  double cutoff,
) {
  double r = 2.0 * 3.14 * cutoff * elapsed_time;
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
  double minCutoff;
  double beta;
  double dCutoff;
  double xPrev = 0.0;
  double dxPrev = 0.0;
  DateTime lastTime = DateTime.now();

  OneEuroFilter({
    this.minCutoff = 2.0,
    this.beta = 0.0,
    this.dCutoff = 1.0,
  });

  double filter(double x) {
    var now = DateTime.now();
    var elapsedTime = now.difference(lastTime).inMilliseconds / 1000.0;

    if (elapsedTime <= 0.0001) {
      xPrev = x;
      return x;
    }

    lastTime = now;

    // The filtered derivative of the signal.
    var alphaD = smoothing_factor(elapsedTime, dCutoff);
    var dx = (x - xPrev) / elapsedTime;
    var dxHat = exponential_smoothing(dx, dxPrev, alphaD);

    // The filtered signal.
    var cutoff = minCutoff + beta * dxHat.abs();
    var alpha = smoothing_factor(elapsedTime, cutoff);
    var xHat = exponential_smoothing(x, xPrev, alpha);

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

      var filteredX = worldFilters[type]!['x']!.filter(landmark.x);
      var filteredY = worldFilters[type]!['y']!.filter(landmark.y);
      var filteredZ = worldFilters[type]!['z']!.filter(landmark.z);

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

      var filteredX = landmarkFilters[type]!['x']!.filter(landmark.x);
      var filteredY = landmarkFilters[type]!['y']!.filter(landmark.y);
      var filteredZ = landmarkFilters[type]!['z']!.filter(landmark.z);

      // Update the landmark coordinates directly
      landmark.updateCoordinates(filteredX, filteredY, filteredZ);
    });

    // Since updates are in-place, just return the modified poseData
    return poseData;
  }
}
