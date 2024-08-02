//
//  NativeVideoView.swift
//  pose_view_ios
//
//  Created by Pham Son on 2/8/24.
//

import AVFoundation
import Flutter
import Foundation

@available(iOS 13.0, *)
class NativeVideoView: NSObject, FlutterPlatformView {
  private var videoViewController: UIViewController?
  private var poseDataStreamHandler: PoseDataStreamHandler?
  private var videoBundlePath: String

  private struct Constants {
    static let storyBoardName = "VideoView"
    static let videoViewControllerStoryBoardId = "VIDEO_VIEW_CONTROLLER"
  }

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?,
    registrar: FlutterPluginRegistrar,
    poseDataStreamHandler: PoseDataStreamHandler,
    videoBundlePath: String
  ) {
    self.poseDataStreamHandler = poseDataStreamHandler
    self.videoBundlePath = videoBundlePath
    super.init()
    instantiateVideoViewController()
  }

  func view() -> UIView {
    guard let videoViewController = videoViewController else {
      return UIView()
    }

    return videoViewController.view
  }

  private func instantiateVideoViewController() {
    guard
      let viewController = UIStoryboard.init(
        name: Constants.storyBoardName,
        bundle: Bundle.init(for: NativeVideoView.self)
      ).instantiateViewController(
        withIdentifier: Constants.videoViewControllerStoryBoardId
      ) as? VideoViewController
    else {
      return
    }

    videoViewController = viewController
    (videoViewController as! VideoViewController).setPoseDataStreamHandler(
      poseStreamHandler: poseDataStreamHandler!)
    (videoViewController as! VideoViewController).setVideoPath(
      videoPath: videoBundlePath
    )
  }
}
