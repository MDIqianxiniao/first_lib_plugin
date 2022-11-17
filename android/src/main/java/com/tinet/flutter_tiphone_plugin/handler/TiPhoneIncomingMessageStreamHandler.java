package com.tinet.flutter_tiphone_plugin.handler;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class TiPhoneIncomingMessageStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink incomingEventSink;

    private volatile static TiPhoneIncomingMessageStreamHandler instance;

    public static TiPhoneIncomingMessageStreamHandler getInstance(){
        if(instance == null){
            synchronized (TiPhoneIncomingMessageStreamHandler.class){
                if(instance == null) instance = new TiPhoneIncomingMessageStreamHandler();
            }
        }
        return instance;
    }

    private TiPhoneIncomingMessageStreamHandler(){}

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        incomingEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        incomingEventSink = null;
    }

    public void onMessage(String message) {
        if (incomingEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onMessage");
            result.put("message", message == null ? "" : message);
            incomingEventSink.success(result);
        }
    }

    public void onError(String message) {
        if (incomingEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onError");
            result.put("message", message == null ? "" : message);
            incomingEventSink.success(result);
        }
    }

    @SuppressWarnings("SpellCheckingInspection")
    public void onKickout(){
        if(incomingEventSink != null){
            HashMap<String,String> result = new HashMap<>();
            result.put("funName","onKickout");
            incomingEventSink.success(result);
        }
    }
}
