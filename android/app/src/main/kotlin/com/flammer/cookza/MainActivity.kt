package com.flammer.cookza

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Intent
import android.net.Uri
import android.os.Parcelable
import java.io.BufferedReader

class MainActivity: FlutterActivity() {

    var sharedText: String = ""
    var sharedJson: String = ""


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      GeneratedPluginRegistrant.registerWith(flutterEngine);

      val intent = getIntent()
      handleIntent(intent)

      MethodChannel(getFlutterEngine()!!.getDartExecutor()!!.getBinaryMessenger(), "app.channel.shared.data").setMethodCallHandler(
        object: MethodCallHandler {
          override fun onMethodCall(call: MethodCall, result: Result) {
            if (call.method.contentEquals("getSharedText"))
            {
              result.success(sharedText)
              sharedText = ""
            }
            if (call.method.contentEquals("getSharedJson"))
            {
              result.success(sharedJson)
              sharedJson = ""
            }
          }
        }
      )
  }

  internal fun handleIntent(intent:Intent) {
    val action = intent.getAction()
    val type = intent.getType()
    if (Intent.ACTION_SEND.equals(action) && type != null)
    {
      if ("text/plain" == type)
      {
        handleSendText(intent)
      }
      if ("application/json" == type ) {
        handleSendJson(intent)
      }
    }
  }

  internal fun handleSendText(intent: Intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT) ?: ""
  }

  internal fun handleSendJson(intent: Intent) {
    // retrieve the URI of the shared JSON
    // for whatsapp, the URI may be sth. like content://com.whatsapp.provider.media/item/someID
    val uri = intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as Uri
    // open an input stream for the given URI
    val inputStream = getContentResolver().openInputStream(uri)
    if (inputStream != null) {
      // read the complete content as a string from the input stream
      val content = inputStream.bufferedReader().use(BufferedReader::readText)
      sharedJson = content
    }
  }

  override fun onNewIntent(intent:Intent) {
    // called when app is resumed from paused state (background)
    // e.g. when shared to app but app was already open
    super.onNewIntent(intent)
    handleIntent(intent)
  }
}