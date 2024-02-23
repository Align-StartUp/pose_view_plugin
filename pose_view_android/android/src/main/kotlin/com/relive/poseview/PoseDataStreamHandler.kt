package com.relive.poseview

import android.util.Log
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult
import io.flutter.plugin.common.EventChannel


class PoseDataStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null

    // Handle the stream initialization
    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    // Handle the stream cancellation
    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    // Method to send results to the Dart side
    fun sendResults(results: PoseLandmarkerResult, inputImageHeight: Int, inputImageWidth: Int) {
        if (results.worldLandmarks().isNotEmpty()) {
            val array: MutableMap<String, Any> = mutableMapOf()
            array["poseResult"] = mapResults(results)
            array["inputImageHeight"] = inputImageHeight
            array["inputImageWidth"] = inputImageWidth

            eventSink?.success(array)
        }
    }

    // Convert the results to a map
    private fun mapResults(results: PoseLandmarkerResult): Map<String, List<Map<String, Any>>> {
        val array : MutableMap<String, List<Map<String, Any>>> = mutableMapOf()

        val worldLandmarks: MutableList<Map<String, Any>> = mutableListOf()
        if (results.worldLandmarks().isNotEmpty()) {
            for (worldLandmark in results.worldLandmarks().first()) {
                val landmarkMap: MutableMap<String, Any> = mutableMapOf()
                landmarkMap["x"] = worldLandmark.x()
                landmarkMap["y"] = worldLandmark.y()
                landmarkMap["z"] = worldLandmark.z()
                if (worldLandmark.visibility().isPresent && worldLandmark.presence().isPresent) {
                    landmarkMap["visibility"] = worldLandmark.visibility().get()
                    landmarkMap["presence"] = worldLandmark.presence().get()
                } else {
                    landmarkMap["visibility"] = 0.0
                    landmarkMap["presence"] = 0.0
                }
                worldLandmarks += landmarkMap
            }
        }

        array["worldLandmarks"] = worldLandmarks

        val normalizedLandmarks: MutableList<Map<String, Any>> = mutableListOf()
        if (results.landmarks().isNotEmpty()) {
            for (normalizedLandmark in results.landmarks().first()) {
                val landmarkMap: MutableMap<String, Any> = mutableMapOf()
                landmarkMap["x"] = normalizedLandmark.x()
                landmarkMap["y"] = normalizedLandmark.y()
                landmarkMap["z"] = normalizedLandmark.z()
                if (normalizedLandmark.visibility().isPresent && normalizedLandmark.presence().isPresent) {
                    landmarkMap["visibility"] = normalizedLandmark.visibility().get()
                    landmarkMap["presence"] = normalizedLandmark.presence().get()
                } else {
                    landmarkMap["visibility"] = 0.0
                    landmarkMap["presence"] = 0.0
                }

                normalizedLandmarks += landmarkMap
            }
        }
        array["normalizedLandmarks"] = normalizedLandmarks

        return array
    }

}