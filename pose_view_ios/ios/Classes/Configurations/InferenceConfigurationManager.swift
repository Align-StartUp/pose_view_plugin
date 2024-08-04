// Copyright 2023 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

/**
 * Singleton storing the configs needed to initialize an MediaPipe Tasks object and run inference.
 * Controllers can observe the `InferenceConfigurationManager.notificationName` for any changes made by the user.
 */


struct InferenceConfigurationManager {

    var model: Model
    var delegate: PoseLandmarkerDelegate
    var numPoses: Int
    var minPoseDetectionConfidence: Float
    var minPosePresenceConfidence: Float
    var minTrackingConfidence: Float

    init(
        model: Model = DefaultConstants.model,
        delegate: PoseLandmarkerDelegate = DefaultConstants.delegate,
        numPoses: Int = DefaultConstants.numPoses,
        minPoseDetectionConfidence: Float = DefaultConstants.minPoseDetectionConfidence,
        minPosePresenceConfidence: Float = DefaultConstants.minPosePresenceConfidence,
        minTrackingConfidence: Float = DefaultConstants.minTrackingConfidence
    ) {
        self.model = model
        self.delegate = delegate
        self.numPoses = numPoses
        self.minPoseDetectionConfidence = minPoseDetectionConfidence
        self.minPosePresenceConfidence = minPosePresenceConfidence
        self.minTrackingConfidence = minTrackingConfidence
    }

}
