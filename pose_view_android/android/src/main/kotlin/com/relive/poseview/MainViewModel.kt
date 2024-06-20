package com.relive.poseview

import androidx.lifecycle.ViewModel

/**
 *  This ViewModel is used to store pose landmarker helper settings
 */
//data class MainViewModel (
//    var model: Int = PoseLandmarkerHelper.MODEL_POSE_LANDMARKER_FULL,
//    var delegate: Int = PoseLandmarkerHelper.DELEGATE_GPU,
//    var minPoseDetectionConfidence: Float = PoseLandmarkerHelper.DEFAULT_POSE_DETECTION_CONFIDENCE,
//    var minPoseTrackingConfidence: Float = PoseLandmarkerHelper.DEFAULT_POSE_TRACKING_CONFIDENCE,
//    var minPosePresenceConfidence: Float = PoseLandmarkerHelper.DEFAULT_POSE_PRESENCE_CONFIDENCE
//)

class MainViewModel (
    private var model: Int = PoseLandmarkerHelper.MODEL_POSE_LANDMARKER_FULL,
    private var delegate: Int = PoseLandmarkerHelper.DELEGATE_GPU,
    private var minPoseDetectionConfidence: Float = PoseLandmarkerHelper.DEFAULT_POSE_DETECTION_CONFIDENCE,
    private var minPoseTrackingConfidence: Float = PoseLandmarkerHelper.DEFAULT_POSE_TRACKING_CONFIDENCE,
    private var minPosePresenceConfidence: Float = PoseLandmarkerHelper.DEFAULT_POSE_PRESENCE_CONFIDENCE
) {

    val currentDelegate: Int get() = delegate
    val currentModel: Int get() = model
    val currentMinPoseDetectionConfidence: Float
        get() =
            minPoseDetectionConfidence
    val currentMinPoseTrackingConfidence: Float
        get() =
            minPoseTrackingConfidence
    val currentMinPosePresenceConfidence: Float
        get() =
            minPosePresenceConfidence

    fun setDelegate(delegate: Int) {
        this.delegate = delegate
    }

    fun setMinPoseDetectionConfidence(confidence: Float) {
        minPoseDetectionConfidence = confidence
    }

    fun setMinPoseTrackingConfidence(confidence: Float) {
        minPoseTrackingConfidence = confidence
    }

    fun setMinPosePresenceConfidence(confidence: Float) {
        minPosePresenceConfidence = confidence
    }

    fun setModel(model: Int) {
        this.model = model
    }
}