package com.tinet.flutter_tiphone_plugin;

import androidx.annotation.NonNull;

import com.tinet.flutter_tiphone_plugin.handler.TiPhoneIncomingMessageStreamHandler;
import com.tinet.flutter_tiphone_plugin.handler.TiPhoneLoginOutStreamHandler;
import com.tinet.flutter_tiphone_plugin.handler.TiPhoneLoginStreamHandler;
import com.tinet.flutter_tiphone_plugin.handler.TiPhoneMethodHandler;
import com.tinet.flutter_tiphone_plugin.handler.TiPhoneSdkEventStreamHandler;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

/** FlutterTiphonePlugin */
public class FlutterTiphonePlugin implements FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;
  private EventChannel loginEventChannel;
  private EventChannel loginOutEventChannel;
  private EventChannel sdkEventChannel;
  private EventChannel incomingMessageEventChannel;

  public static String LOG_TAG = "flutter_tiPhone_plugin";


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel  = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),"method_channel/tiphone");
    methodChannel.setMethodCallHandler(new TiPhoneMethodHandler(flutterPluginBinding.getApplicationContext()));

    loginEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "event_channel/tiphone/login_event");
    loginEventChannel.setStreamHandler(TiPhoneLoginStreamHandler.getInstance());

    loginOutEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "event_channel/tiphone/login_out_event");
    loginOutEventChannel.setStreamHandler(TiPhoneLoginOutStreamHandler.getInstance());

    sdkEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "event_channel/tiphone/sdk_event");
    sdkEventChannel.setStreamHandler(TiPhoneSdkEventStreamHandler.getInstance());

    incomingMessageEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "event_channel/tiphone/incoming_message_event");
    incomingMessageEventChannel.setStreamHandler(TiPhoneIncomingMessageStreamHandler.getInstance());
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);

    loginEventChannel.setStreamHandler(null);
    loginOutEventChannel.setStreamHandler(null);
    sdkEventChannel.setStreamHandler(null);
    incomingMessageEventChannel.setStreamHandler(null);
  }
}
