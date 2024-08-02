//
//  NativeCameraView.swift
//  Runner
//
//  Created by ios on 07/12/2023.
//

import AVFoundation
import Flutter
import Foundation

@available(iOS 13.0, *)
class NativeCameraView: NSObject, FlutterPlatformView {
  private var cameraViewController: UIViewController?
  private var poseDataStreamHandler: PoseDataStreamHandler?

  private struct Constants {
    static let storyBoardName = "CameraView"
    static let cameraViewControllerStoryBoardId = "CAMERA_VIEW_CONTROLLER"
  }

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?,
    registrar: FlutterPluginRegistrar,
    poseDataStreamHandler: PoseDataStreamHandler
  ) {
    print(Bundle.init(for: NativeCameraView.self).bundlePath)
    print(Bundle.init(for: NativeCameraView.self).bundleURL)
    self.poseDataStreamHandler = poseDataStreamHandler
    super.init()
    instantiateCameraViewController()
  }

  func view() -> UIView {
    guard let cameraViewController = cameraViewController else {
      return UIView()
    }

    return cameraViewController.view
  }

  private func instantiateCameraViewController() {
    guard
      let viewController = UIStoryboard.init(
        name: Constants.storyBoardName,
        bundle: Bundle.init(for: NativeCameraView.self)
      ).instantiateViewController(
        withIdentifier: Constants.cameraViewControllerStoryBoardId
      ) as? CameraViewController
    else {
      return
    }

    cameraViewController = viewController
    (cameraViewController as! CameraViewController).setPoseDataStreamHandler(
      poseStreamHandler: poseDataStreamHandler!)
  }
}
