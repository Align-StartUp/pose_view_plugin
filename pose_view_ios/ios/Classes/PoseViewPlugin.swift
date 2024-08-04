import Flutter
import UIKit

public class PoseViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "pose_view_ios", binaryMessenger: registrar.messenger())
    let instance = PoseViewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let POSE_CHANNEL = "fit_worker/pose_data_stream"
    let poseDataStreamHandler = PoseDataStreamHandler()

    let poseChannel = FlutterEventChannel(
      name: POSE_CHANNEL, binaryMessenger: registrar.messenger())
    poseChannel.setStreamHandler(poseDataStreamHandler)

    let cameraViewFactory = NativeCameraViewFactory(
      registrar: registrar, poseDataStreamHandler: poseDataStreamHandler)
    registrar.register(cameraViewFactory, withId: "@views/camera-pose-view")

    let videoViewFactory = NativeVideoViewFactory(
      registrar: registrar, poseDataStreamHandler: poseDataStreamHandler)
    registrar.register(videoViewFactory, withId: "@views/video-pose-view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformName":
      result("iOS")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
