package com.anderssundheim.doorman

import android.content.Intent
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import androidx.core.content.FileProvider;

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView,"channel:me.doorman.share/share").setMethodCallHandler { methodCall, _ ->
      if (methodCall.method == "shareFile") {
        shareFile(methodCall.arguments as String)
      }
    }
  }
  private fun shareFile(path:String) {
    val imageFile = File(this.applicationContext.cacheDir,path)
    val contentUri = FileProvider.getUriForFile(this,"me.doorman.share",imageFile)

    val shareIntent = Intent()
    shareIntent.action = Intent.ACTION_SEND
    shareIntent.type="image/jpg"
    shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)
    startActivity(Intent.createChooser(shareIntent,"Share image using"))
  }
}
