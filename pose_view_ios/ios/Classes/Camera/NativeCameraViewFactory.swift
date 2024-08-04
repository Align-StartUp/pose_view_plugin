//
//  FLNativeView.swift
//  Runner
//
//  Created by ios on 06/12/2023.
//

import Flutter
import UIKit

@available(iOS 13.0, *)
class NativeCameraViewFactory: NSObject, FlutterPlatformViewFactory {
  private var registrar: FlutterPluginRegistrar
  private var poseDataStreamHandler: PoseDataStreamHandler

  init(registrar: FlutterPluginRegistrar, poseDataStreamHandler: PoseDataStreamHandler) {
    self.registrar = registrar
    self.poseDataStreamHandler = poseDataStreamHandler
    super.init()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let creationParams = args as! [String: Any]
      
    let options = creationParams["options"] as! [String: Any]

    let modelValue = options["model"] as! Int
    let model = Model(rawValue: modelValue)!

    let delegateValue = options["delegate"] as! Int
    let delegate: PoseLandmarkerDelegate = {
        switch delegateValue {
        case 0:
            return .CPU
        case 1:
            return .GPU
        default:
            fatalError("Invalid delegate value")
        }
    }()

    let inferenceConfig = InferenceConfigurationManager(
      model: model,
      delegate: delegate,
      minPoseDetectionConfidence: options["minPoseDetectionConfidence"] as! Float,
      minPosePresenceConfidence: options["minPosePresenceConfidence"] as! Float,
      minTrackingConfidence: options["minPoseTrackingConfidence"] as! Float
    )

    return NativeCameraView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: registrar.messenger(),
      registrar: registrar,
      poseDataStreamHandler: poseDataStreamHandler,
      inferenceConfig: inferenceConfig
    )
  }

  /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}
