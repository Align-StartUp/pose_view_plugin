package com.relive.poseview

import android.content.Context
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.relive.poseview.camera.NativeCameraView
import com.relive.poseview.camera.NativeCameraViewFactory
import com.relive.poseview.video.VideoViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView


class PoseViewPlugin : FlutterPlugin, MethodCallHandler ,ActivityAware {
    private lateinit var channel: MethodChannel
    private var TAG: String = "PoseViewPlugin"

    private val POSE_CHANNEL = "fit_worker/pose_data_stream"

    private var context: Context? = null
    private var controller: ViewController = ViewController()
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    private lateinit var poseChannel: EventChannel
    private lateinit var poseDataStreamHandler : PoseDataStreamHandler

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformName" -> {
                result.success("Android")
            }
            "getNativeCameraView" -> {
                result.notImplemented()
            }
            "getSimulatedCameraView" -> {
                result.notImplemented()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "Attached to activity")
        val owner = binding.activity as LifecycleOwner
        Log.d(TAG, "Owner is $owner")

        val viewModel = MainViewModel()

        poseChannel = EventChannel(flutterPluginBinding.binaryMessenger, POSE_CHANNEL)
        poseDataStreamHandler = PoseDataStreamHandler()
        poseChannel.setStreamHandler(poseDataStreamHandler)

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pose_view_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        val flutterAssets = flutterPluginBinding.flutterAssets
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("@views/camera-pose-view", NativeCameraViewFactory(
                    viewModel, binding.activity, owner, controller, poseDataStreamHandler, flutterPluginBinding.binaryMessenger
                )
            )

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("@views/video-pose-view", VideoViewFactory(
                    viewModel, flutterAssets, binding.activity, owner, controller, poseDataStreamHandler, flutterPluginBinding.binaryMessenger
                )
            )

        controller.setLifecycleProvider(ProxyLifecycleProvider(binding.activity))
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "Detached to activity")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d(TAG, "Attached to activity")
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "Detached to activity")
    }
}

interface NativeView : PlatformView {
    fun onCreate()
    fun onPause()
    fun onResume()
    fun onDestroyView()
}

class ViewController : DefaultLifecycleObserver {
    private lateinit var view : NativeView
    private val TAG: String = "CameraController"

    private var initialized: Boolean = false

    fun setView(view: NativeView) {
        this.view = view
        initialized = true

        view.onCreate()
    }

    fun setLifecycleProvider(proxyLifecycleProvider: ProxyLifecycleProvider) {
        proxyLifecycleProvider.lifecycle.addObserver(this)
    }

    override fun onPause(owner: LifecycleOwner) {
        if (!initialized) {
            return;
        }

        Log.d(TAG, "onPause")

        super.onPause(owner)
        view.onPause()
    }

    override fun onResume(owner: LifecycleOwner) {
        if (!initialized) {
            return;
        }

        Log.d(TAG, "onResume")

        super.onResume(owner)
        view.onResume()
    }

    override fun onDestroy(owner: LifecycleOwner) {
        if (!initialized) {
            return;
        }

        Log.d(TAG, "onDestroy")

        super.onDestroy(owner)
        view.onDestroyView()
    }
}