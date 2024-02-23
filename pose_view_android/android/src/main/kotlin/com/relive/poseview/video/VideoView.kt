package com.relive.poseview.video

import android.app.Activity
import android.content.Context
import android.content.res.AssetFileDescriptor
import android.graphics.Bitmap
import android.graphics.SurfaceTexture
import android.media.MediaPlayer
import android.util.Log
import android.view.LayoutInflater
import android.view.Surface
import android.view.TextureView
import android.view.TextureView.SurfaceTextureListener
import android.view.View
import android.widget.Toast
import androidx.lifecycle.LifecycleOwner
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.relive.poseview.ViewController
import com.relive.poseview.MainViewModel
import com.relive.poseview.NativeView
import com.relive.poseview.PoseDataStreamHandler
import com.relive.poseview.PoseLandmarkerHelper
import io.flutter.plugin.common.BinaryMessenger
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import com.relive.poseview.databinding.VideoBinding
import java.io.IOException
import java.util.concurrent.ExecutorService


class VideoView internal constructor(
    private val context: Context,
    private val videoFd: AssetFileDescriptor,
    private val viewModel: MainViewModel,
    private val activity: Activity,
    private val owner: LifecycleOwner,
    private val controller: ViewController,
    private val poseDataStreamHandler: PoseDataStreamHandler,
    private val messenger: BinaryMessenger,
    id: Int,
)
    : NativeView, PoseLandmarkerHelper.LandmarkerListener {

    private val TAG: String = "Video Pose Landmarker"

    private var _videoViewBinding: VideoBinding? = null
    private val videoViewBinding
        get() = _videoViewBinding!!
    private lateinit var poseLandmarkerHelper: PoseLandmarkerHelper

    /** Blocking ML operations are performed using this executor */
    private lateinit var backgroundExecutor: ExecutorService

    private var mediaPlayer: MediaPlayer
    private var textureView: TextureView

    init {
        _videoViewBinding = VideoBinding.inflate(LayoutInflater.from(context))

        textureView = _videoViewBinding!!.videoView

        mediaPlayer = MediaPlayer()
        mediaPlayer.isLooping = true;

        textureView.surfaceTextureListener = object : SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(
                surface: SurfaceTexture,
                width: Int,
                height: Int
            ) {
                val surfaceObject = Surface(surface)

                try {
                    mediaPlayer.setDataSource(videoFd)
                    mediaPlayer.setSurface(surfaceObject)
                    mediaPlayer.prepare()

                    mediaPlayer.setOnPreparedListener { mediaPlayer.start() }
                } catch (e : IOException) {
                    e.printStackTrace()
                }
            }

            override fun onSurfaceTextureSizeChanged(
                surface: SurfaceTexture,
                width: Int,
                height: Int
            ) {
            }

            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean {
                // Close the PoseLandmarkerHelper and release resources
                backgroundExecutor.execute { poseLandmarkerHelper.clearPoseLandmarker() }

                return false
            }

            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {

                backgroundExecutor.execute {
                    textureView.bitmap?.let { detectPose(it) }
                }

            }
        }

        controller.setView(this)
    }

    private fun detectPose(image: Bitmap) {
        if(this::poseLandmarkerHelper.isInitialized) {
            poseLandmarkerHelper.detectImageStream(
                image = image,
                isFrontCamera = true
            )
        } else {
            Log.e(TAG, "PoseLandmarkerHelper has not been initialized yet.")
        }
    }


    override fun onCreate() {
        // Initialize our background executor
        backgroundExecutor = Executors.newSingleThreadExecutor()

        // Create the PoseLandmarkerHelper that will handle the inference
        backgroundExecutor.execute {
            poseLandmarkerHelper = PoseLandmarkerHelper(
                context = context,
                runningMode = RunningMode.LIVE_STREAM,
                minPoseDetectionConfidence = viewModel.currentMinPoseDetectionConfidence,
                minPoseTrackingConfidence = viewModel.currentMinPoseTrackingConfidence,
                minPosePresenceConfidence = viewModel.currentMinPosePresenceConfidence,
                currentDelegate = viewModel.currentDelegate,
                poseLandmarkerHelperListener = this
            )
        }
    }

    override fun onPause() {
        if(this::poseLandmarkerHelper.isInitialized) {
            viewModel.setMinPoseDetectionConfidence(poseLandmarkerHelper.minPoseDetectionConfidence)
            viewModel.setMinPoseTrackingConfidence(poseLandmarkerHelper.minPoseTrackingConfidence)
            viewModel.setMinPosePresenceConfidence(poseLandmarkerHelper.minPosePresenceConfidence)
            viewModel.setDelegate(poseLandmarkerHelper.currentDelegate)

            // Close the PoseLandmarkerHelper and release resources
            backgroundExecutor.execute { poseLandmarkerHelper.clearPoseLandmarker() }
        }

        if (mediaPlayer.isPlaying) {
            mediaPlayer.pause()
        }
    }

    override fun onResume() {
        // Start the PoseLandmarkerHelper again when users come back
        // to the foreground.
        backgroundExecutor.execute {
            if(this::poseLandmarkerHelper.isInitialized) {
                if (poseLandmarkerHelper.isClose()) {
                    poseLandmarkerHelper.setupPoseLandmarker()
                }
            }
        }

        if (!mediaPlayer.isPlaying) {
            mediaPlayer.start()
        }
    }

    override fun onDestroyView() {
        _videoViewBinding = null

        // Shut down our background executor
        backgroundExecutor.shutdown()
        backgroundExecutor.awaitTermination(
            Long.MAX_VALUE, TimeUnit.NANOSECONDS
        )
    }

    override fun onError(error: String, errorCode: Int) {
        activity.runOnUiThread {
            Toast.makeText(context, error, Toast.LENGTH_SHORT).show()
            if (errorCode == PoseLandmarkerHelper.GPU_ERROR) {
                // TODO: Switch to CPU
            }
        }
    }

    override fun onResults(resultBundle: PoseLandmarkerHelper.ResultBundle) {
        activity.runOnUiThread {
            poseDataStreamHandler.sendResults(
                resultBundle.results.first(),
                resultBundle.inputImageHeight,
                resultBundle.inputImageWidth
            )

//            // Log inference info
//            Log.d(
//                TAG,
//                "Inference: " +
//                        "${resultBundle.inferenceTime} ms, Frame size: " +
//                        "${resultBundle.inputImageWidth}x${resultBundle.inputImageHeight}"
//            )
        }
    }

    companion object {
        private const val TAG = "GalleryFragment"

        // Value used to get frames at specific intervals for inference (e.g. every 300ms)
        private const val VIDEO_INTERVAL_MS = 300L
    }

    override fun getView(): View {
        return videoViewBinding.root
    }

    override fun dispose() {
        // Close the PoseLandmarkerHelper and release resources
        backgroundExecutor.execute { poseLandmarkerHelper.clearPoseLandmarker() }

        // Shut down our background executor
        backgroundExecutor.shutdown()
        backgroundExecutor.awaitTermination(
            Long.MAX_VALUE, TimeUnit.NANOSECONDS
        )

        mediaPlayer.stop()
        mediaPlayer.release()
    }
}