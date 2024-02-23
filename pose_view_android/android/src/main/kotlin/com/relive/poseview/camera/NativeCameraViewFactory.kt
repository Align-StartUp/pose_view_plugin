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
    private val viewModel: MainViewModel,
    private val activity: Activity,
    private val owner: LifecycleOwner,
    private val cameraController: ViewController,
    private val poseDataStreamHandler: PoseDataStreamHandler,
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return NativeCameraView(context, viewModel, activity, owner, cameraController, poseDataStreamHandler, messenger, viewId)
    }
}
