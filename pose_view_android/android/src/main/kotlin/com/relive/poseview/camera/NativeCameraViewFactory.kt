package com.relive.poseview.camera

import android.app.Activity
import android.content.Context
import androidx.lifecycle.LifecycleOwner
import com.relive.poseview.ViewController
import com.relive.poseview.MainViewModel
import com.relive.poseview.PoseDataStreamHandler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeCameraViewFactory(
    private val activity: Activity,
    private val owner: LifecycleOwner,
    private val cameraController: ViewController,
    private val poseDataStreamHandler: PoseDataStreamHandler,
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

        // Create ViewModel from options
        val options = creationParams?.get("options") as Map<String, Any>
        val viewModel = MainViewModel(
            options["model"] as Int,
            options["delegate"] as Int,
            (options["minPoseDetectionConfidence"] as Double).toFloat(),
            (options["minPoseTrackingConfidence"] as Double).toFloat(),
            (options["minPosePresenceConfidence"] as Double).toFloat(),
        )

        return NativeCameraView(context, viewModel, activity, owner, cameraController, poseDataStreamHandler, messenger, viewId)
    }
}
