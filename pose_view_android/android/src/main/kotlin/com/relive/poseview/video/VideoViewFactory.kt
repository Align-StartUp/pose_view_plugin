package com.relive.poseview.video

import android.app.Activity
import android.content.Context
import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import com.relive.poseview.ViewController
import com.relive.poseview.MainViewModel
import com.relive.poseview.PoseDataStreamHandler
import com.relive.poseview.camera.NativeCameraView
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class VideoViewFactory(
    private val viewModel: MainViewModel,
    private val flutterAssets: FlutterAssets,
    private val activity: Activity,
    private val owner: LifecycleOwner,
    private val controller: ViewController,
    private val poseDataStreamHandler: PoseDataStreamHandler,
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

        // Extract videoPath from creationParams
        val videoPath = creationParams?.get("videoPath") as String?

        Log.d("VideoViewFactory", "videoPath: $videoPath")

        val assetManager: AssetManager = context.assets
        val video = videoPath?.let { flutterAssets.getAssetFilePathByName(it) };

        val videoFd: AssetFileDescriptor = assetManager.openFd(video!!)

        Log.d("VideoViewFactory", "video: $video")
        Log.d("VideoViewFactory", "videoFd: $videoFd")
        Log.d("VideoViewFactory", "viewFdLength: ${videoFd.length}")

        return VideoView(context, videoFd, viewModel, activity, owner, controller, poseDataStreamHandler, messenger, viewId)
    }
}
