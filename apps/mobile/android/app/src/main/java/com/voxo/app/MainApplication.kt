package com.voxo.app

import android.app.Application
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactHost
import com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import com.livekit.reactnative.LiveKitReactNative
import com.livekit.reactnative.audio.AudioType

class MainApplication : Application(), ReactApplication {

  override val reactHost: ReactHost by lazy {
    getDefaultReactHost(
      context = applicationContext,
      packageList =
        PackageList(this).packages.apply {
          // Autolinked packages
        },
    )
  }

  override fun onCreate() {
    super.onCreate()

    // Initialize LiveKit before React Native.
    LiveKitReactNative.setup(
      this,
      AudioType.CommunicationAudioType()
    )

    loadReactNative(this)
  }
}
