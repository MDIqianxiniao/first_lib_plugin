package com.tinet.flutter_tiphone_plugin.handler;

import com.tinet.janussdk.bean.LoginResultBean;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class TiPhoneLoginOutStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink loginOutEventSink;

    private volatile static TiPhoneLoginOutStreamHandler instance;

    public static TiPhoneLoginOutStreamHandler getInstance(){
        if(instance == null){
            synchronized (TiPhoneLoginOutStreamHandler.class){
                if(instance == null) instance = new TiPhoneLoginOutStreamHandler();
            }
        }
        return instance;
    }

    private TiPhoneLoginOutStreamHandler(){}


    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        loginOutEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        loginOutEventSink = null;
    }

    public void loginOutOnError(String message) {
        if (loginOutEventSink != null) {
            HashMap<String, String> result = new HashMap<>();
            result.put("funName", "onError");
            result.put("message", message == null ? "" : message);
            loginOutEventSink.success(result);
        }
    }

    public void loginOutOnNext(LoginResultBean loginResultBean){
        if(loginOutEventSink != null){
            HashMap<String,String> result = new HashMap<>();
            result.put("funName","onNext");
            result.put("code",String.valueOf(loginResultBean.getCode()));
            String message = loginResultBean.getMessage();
            result.put("message",message == null?"":message);
            String cnoNum = loginResultBean.getUserCno();
            result.put("cnoNum",cnoNum == null?"":cnoNum);
            loginOutEventSink.success(result);
        }
    }
}
