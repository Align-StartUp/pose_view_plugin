//
//  PoseDataStreamHandler.swift
//  Runner
//
//  Created by ios on 06/12/2023.
//

import Flutter
import Foundation
import MediaPipeTasksVision

class PoseDataStreamHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    self.eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  func sendResults(results: PoseLandmarkerResult, inputImageHeight: Int, inputImageWidth: Int) {
    if results.worldLandmarks.isEmpty {
      return
    }

    var array = [String: Any]()

    array["poseResult"] = mapResults(results: results)
    array["inputImageHeight"] = inputImageHeight
    array["inputImageWidth"] = inputImageWidth

    self.eventSink?(array)
  }

  private func mapResults(results: PoseLandmarkerResult) -> [String: Any] {
    var array = [String: Any]()

    var worldLandmarks = [[String: Any]]()
    if !results.worldLandmarks.isEmpty {
      for worldLandmark in results.worldLandmarks.first! {
        var landmarkMap = [String: Any]()
        landmarkMap["x"] = worldLandmark.x
        landmarkMap["y"] = worldLandmark.y
        landmarkMap["z"] = worldLandmark.z
        if worldLandmark.visibility != nil && worldLandmark.presence != nil {
          landmarkMap["visibility"] = worldLandmark.visibility
          landmarkMap["presence"] = worldLandmark.presence
        } else {
          landmarkMap["visibility"] = 0.0
          landmarkMap["presence"] = 0.0
        }
        worldLandmarks.append(landmarkMap)
      }
    }

    array["worldLandmarks"] = worldLandmarks

    var normalizedLandmarks = [[String: Any]]()
    if !results.landmarks.isEmpty {
      for normalizedLandmark in results.landmarks.first! {
        var landmarkMap = [String: Any]()
        landmarkMap["x"] = normalizedLandmark.x
        landmarkMap["y"] = normalizedLandmark.y
        landmarkMap["z"] = normalizedLandmark.z
        if normalizedLandmark.visibility != nil && normalizedLandmark.presence != nil {
          landmarkMap["visibility"] = normalizedLandmark.visibility
          landmarkMap["presence"] = normalizedLandmark.presence
        } else {
          landmarkMap["visibility"] = 0.0
          landmarkMap["presence"] = 0.0
        }
        normalizedLandmarks.append(landmarkMap)
      }
    }

    array["normalizedLandmarks"] = normalizedLandmarks

    return array
  }

}
