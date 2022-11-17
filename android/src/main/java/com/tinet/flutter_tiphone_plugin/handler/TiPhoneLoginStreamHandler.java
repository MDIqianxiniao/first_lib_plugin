package com.tinet.flutter_tiphone_plugin.handler;

import com.tinet.janussdk.bean.LoginResultBean;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class TiPhoneLoginStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink loginEventSink;

    private volatile static TiPhoneLoginStreamHandler instance;

    public static TiPhoneLoginStreamHandler getInstance(){
        if(instance == null){
            synchronized (TiPhoneLoginStreamHandler.class){
                if(instance == null) instance = new TiPhoneLoginStreamHandler();
            }
        }
        return instance;
    }

    private TiPhoneLoginStreamHandler(){}

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        loginEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        loginEventSink = null;
    }

    public void loginOnError(String message) {
        if (loginEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onError");
            result.put("message", message == null ? "" : message);
            loginEventSink.success(result);
        }
    }

    public void loginOnNext(LoginResultBean loginResultBean){
        if(loginEventSink != null){
            HashMap<String,String> result = new HashMap<>();
            result.put("funName","onNext");
            result.put("code",String.valueOf(loginResultBean.getCode()));
            String message = loginResultBean.getMessage();
            result.put("message",message == null?"":message);
            String cnoNum = loginResultBean.getUserCno();
            result.put("cnoNum",cnoNum == null?"":cnoNum);
            loginEventSink.success(result);
        }
    }

}

