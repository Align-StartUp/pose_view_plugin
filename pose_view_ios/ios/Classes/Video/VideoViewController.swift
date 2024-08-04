//
//  NativeVideoViewController.swift
//  pose_view_ios
//
//  Created by Pham Son on 2/8/24.
//

import AVKit
import MediaPipeTasksVision
import UIKit

/// The view controller is responsible for performing detection on videos or images selected by the user from the device media library and
/// presenting them with the landmarks of the pose to the user.
class VideoViewController: UIViewController {

  // MARK: Private properties
  private var playerTimeObserverToken: Any?

  // MARK: Storyboards Connections
  @IBOutlet weak var previewView: UIView!

  private let backgroundQueue = DispatchQueue(
    label: "com.google.mediapipe.videoController.backgroundQueue")

  private let poseLandmarkerServiceQueue = DispatchQueue(
    label: "com.google.mediapipe.videoController.poseLandmarkerServiceQueue",
    attributes: .concurrent)

  // MARK: Controllers that manage functionality
  private lazy var pickerController = UIImagePickerController()
  private var playerViewController: AVPlayerViewController?

  // MARK: Pose Landmarker Service
  private var _poseLandmarkerService: PoseLandmarkerService?
  private var poseLandmarkerService: PoseLandmarkerService? {
    get {
      poseLandmarkerServiceQueue.sync {
        return self._poseLandmarkerService
      }
    }
    set {
      poseLandmarkerServiceQueue.async(flags: .barrier) {
        self._poseLandmarkerService = newValue
      }
    }
  }

  // poseStreamHandler
  private var poseStreamHandler: PoseDataStreamHandler?

  func setPoseDataStreamHandler(poseStreamHandler: PoseDataStreamHandler) {
    self.poseStreamHandler = poseStreamHandler
  }

  private var inferenceConfig: InferenceConfigurationManager?

  func setInferenceConfig(inferenceConfig: InferenceConfigurationManager) {
    self.inferenceConfig = inferenceConfig
  }

  private var videoPath: String?
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var videoOutput: AVPlayerItemVideoOutput?
  private var displayLink: CADisplayLink?

  func setVideoPath(videoPath: String) {
    self.videoPath = videoPath
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    initializePoseLandmarkerServiceOnSessionResumption()
    playerLayer?.frame = previewView.bounds
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    poseLandmarkerService = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupVideoPlayer()
    setupDisplayLink()
  }

  private func setupVideoPlayer() {
    guard let videoPath = videoPath else {
      return
    }
    let playerItem = AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: videoPath)))

    player = AVPlayer(playerItem: playerItem)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer?.videoGravity = .resizeAspectFill

    if let playerLayer = playerLayer {
      previewView.layer.addSublayer(playerLayer)
      playerLayer.frame = previewView.bounds
    }

    // Set up video output
    let outputSettings: [String: Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
    ]
    videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: outputSettings)
    playerItem.add(videoOutput!)

    NotificationCenter.default.addObserver(
      self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime,
      object: player?.currentItem)

    player?.play()
  }

  @objc private func loopVideo() {
    player?.seek(to: .zero)
    player?.play()
  }

  private func setupDisplayLink() {
    let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidUpdate))
    displayLink.add(to: .current, forMode: .default)
  }

  @objc private func displayLinkDidUpdate() {
    guard let player = player, player.currentItem?.status == .readyToPlay else {
      return
    }
    let currentTime = player.currentTime()
    let currentPixelBuffer = videoOutput?.copyPixelBuffer(
      forItemTime: currentTime, itemTimeForDisplay: nil)

    backgroundQueue.async {
      guard let pixelBuffer = currentPixelBuffer else {
        return
      }
      let orientation = UIImage.Orientation.up
      let currentTimeMs = Date().timeIntervalSince1970 * 1000
      self.poseLandmarkerService?.detectAsync(
        pixelBuffer: pixelBuffer, orientation: orientation, timeStamps: Int(currentTimeMs))
    }
  }

  private func initializePoseLandmarkerServiceOnSessionResumption() {
    clearAndInitializePoseLandmarkerService()
  }

  @objc private func clearAndInitializePoseLandmarkerService() {
    poseLandmarkerService = nil
    poseLandmarkerService =
      PoseLandmarkerService
      .liveStreamPoseLandmarkerService(
        modelPath: inferenceConfig!.model.modelPath,
        numPoses: inferenceConfig!.numPoses,
        minPoseDetectionConfidence: inferenceConfig!.minPoseDetectionConfidence,
        minPosePresenceConfidence: inferenceConfig!.minPosePresenceConfidence,
        minTrackingConfidence: inferenceConfig!.minTrackingConfidence,
        liveStreamDelegate: self,
        delegate: inferenceConfig!.delegate)

    print(
      "Model path: \(String(describing: inferenceConfig!.model.modelPath))"
    )
    print("PoseLandmarkerService initialized")
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    playerLayer?.frame = previewView.bounds
  }
    
  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      playerLayer?.frame = previewView.bounds
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait  // Only allow portrait orientation
  }

  override var shouldAutorotate: Bool {
    return false  // Disable autorotation
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    displayLink?.invalidate()
  }
}

extension VideoViewController: PoseLandmarkerServiceLiveStreamDelegate {

  func poseLandmarkerService(
    _ poseLandmarkerService: PoseLandmarkerService,
    didFinishDetection result: ResultBundle?,
    error: Error?
  ) {
    DispatchQueue.main.async { [weak self] in
      guard let weakSelf = self else { return }
      guard let poseLandmarkerResult = result?.poseLandmarkerResults.first as? PoseLandmarkerResult
      else { return }

      let imageSize = self?.playerLayer?.videoRect.size ?? CGSize.zero

      guard let poseStreamHandler = weakSelf.poseStreamHandler else { return }
      poseStreamHandler.sendResults(
        results: poseLandmarkerResult, inputImageHeight: Int(imageSize.height),
        inputImageWidth: Int(imageSize.width))
    }
  }
}
