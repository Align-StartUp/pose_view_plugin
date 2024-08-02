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
    return NativeCameraView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: registrar.messenger(),
      registrar: registrar,
      poseDataStreamHandler: poseDataStreamHandler
    )
  }

  /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}
