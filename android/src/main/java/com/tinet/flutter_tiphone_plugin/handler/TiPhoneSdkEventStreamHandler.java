package com.tinet.flutter_tiphone_plugin.handler;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class TiPhoneSdkEventStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink sdkEventSink;

    private volatile static TiPhoneSdkEventStreamHandler instance;

    public static TiPhoneSdkEventStreamHandler getInstance(){
        if(instance == null){
            synchronized (TiPhoneSdkEventStreamHandler.class){
                if(instance == null) instance = new TiPhoneSdkEventStreamHandler();
            }
        }
        return instance;
    }

    private TiPhoneSdkEventStreamHandler(){}

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        sdkEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        sdkEventSink = null;
    }

    public void sdkErrorEvent(String message) {
        if (sdkEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onError");
            result.put("message", message == null ? "" : message);
            sdkEventSink.success(result);
        }
    }

    public void sdkOnDestroy() {
        if (sdkEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onDestroy");
            sdkEventSink.success(result);
        }
    }

    public void sdkEventChange(String event, String message) {
        if (sdkEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onEventChange");
            result.put("event", event == null ? "" : event);
            result.put("message", message == null ? "" : message);
            sdkEventSink.success(result);
        }
    }
}
