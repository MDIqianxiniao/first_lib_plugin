package com.tinet.flutter_tiphone_plugin.handler;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tinet.flutter_tiphone_plugin.FlutterTiphonePlugin;
import com.tinet.flutter_tiphone_plugin.TiPhoneMethod;
import com.tinet.janussdk.bean.LoginResultBean;
import com.tinet.janussdk.plugin.IIncomingMessageListener;
import com.tinet.janussdk.plugin.OnEventListener;
import com.tinet.janussdk.plugin.TiPhone;
import com.tinet.janussdk.plugin.TiPhoneManagerCallBacks;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TiPhoneMethodHandler implements MethodChannel.MethodCallHandler {

    private final Context context;

    public TiPhoneMethodHandler(Context context) {
        this.context = context;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.d(FlutterTiphonePlugin.LOG_TAG, "call method:" + call.method);
        switch (call.method) {
            case TiPhoneMethod.method_init:
                init();
                break;
            case TiPhoneMethod.method_loginTiPhoneByCrmId:
                loginTiPhoneByCrmId(call, result);
                break;
            case TiPhoneMethod.method_loginTiPhoneByCno:
                loginTiPhoneByCno(call, result);
                break;
            case TiPhoneMethod.method_confirmVerificationCode:
                confirmVerificationCode(call, result);
                break;
            case TiPhoneMethod.method_call:
                call(call, result);
                break;
            case TiPhoneMethod.method_setIncomingMessageListener:
                setIncomingMessageListener(call, result);
                break;
            case TiPhoneMethod.method_loginOutTiPhone:
                loginOutTiPhone(call, result);
                break;
            case TiPhoneMethod.method_hangup:
                hangup(call, result);
                break;
            case TiPhoneMethod.method_setOnEventListener:
                setOnEventListener(call, result);
                break;
            case TiPhoneMethod.method_sendDTMF:
                sendDTMF(call, result);
                break;
            case TiPhoneMethod.method_setMicrophoneMute:
                setMicrophoneMute(call, result);
                break;
            case TiPhoneMethod.method_isSpeakerphoneEnabled:
                isSpeakerphoneEnabled(call, result);
                break;
            case TiPhoneMethod.method_setEnableSpeakerphone:
                setEnableSpeakerphone(call, result);
                break;
            case TiPhoneMethod.method_getVersion:
                getVersion(call, result);
                break;
            case TiPhoneMethod.method_setDebug:
                setDebug(call, result);
                break;
            case TiPhoneMethod.method_setTelExplicit:
                setTelExplicit(call, result);
                break;
        }
    }

    private void init() {
        TiPhone.init(context);
    }

    @SuppressWarnings("ConstantConditions")
    private void loginTiPhoneByCrmId(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().loginTiPhone(
                call.argument("strPlatformUrl"),
                call.argument("enterpriseId"),
                call.argument("crmId"),
                call.argument("password"),
                call.argument("bindTel"),
                call.argument("showName"),
                call.argument("isTelExplicit"),
                new TiPhoneManagerCallBacks() {
                    @Override
                    public void onError(String message) {
                        TiPhoneLoginStreamHandler.getInstance().loginOnError(message);
                    }

                    @Override
                    public void onNext(LoginResultBean loginResultBean) {
                        TiPhoneLoginStreamHandler.getInstance().loginOnNext(loginResultBean);
                    }
                }

        );
    }

    @SuppressWarnings("ConstantConditions")
    private void loginTiPhoneByCno(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().loginTiPhone(
                call.argument("strPlatformUrl"),
                call.argument("enterpriseId"),
                call.argument("crmId"),
                call.argument("password"),
                call.argument("cno"),
                call.argument("token"),
                call.argument("bindTel"),
                call.argument("showName"),
                call.argument("isTelExplicit"),
                new TiPhoneManagerCallBacks() {
                    @Override
                    public void onError(String message) {
                        TiPhoneLoginStreamHandler.getInstance().loginOnError(message);
                    }

                    @Override
                    public void onNext(LoginResultBean loginResultBean) {
                        TiPhoneLoginStreamHandler.getInstance().loginOnNext(loginResultBean);
                    }
                }

        );
    }

    private void confirmVerificationCode(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().confirmVerificationCode(call.argument("code"));
    }

    private void call(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().call(
                call.argument("phoneNumber"),
                call.argument("obClid"),
                call.argument("requestUniqueId"),
                call.argument("userField")
        );
    }

    private void setIncomingMessageListener(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().setIncomingMessageListener(context, new IIncomingMessageListener() {
            @Override
            public void onMessage(String message) {
                TiPhoneIncomingMessageStreamHandler.getInstance().onMessage(message);
            }

            @Override
            public void onError(String message) {
                TiPhoneIncomingMessageStreamHandler.getInstance().onError(message);
            }

            @Override
            public void onKickout(){
                TiPhoneIncomingMessageStreamHandler.getInstance().onKickout();
            }
        });
    }

    private void loginOutTiPhone(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().loginOutTiPhone(new TiPhoneManagerCallBacks() {
            @Override
            public void onError(String message) {
                TiPhoneLoginOutStreamHandler.getInstance().loginOutOnError(message);
            }

            @Override
            public void onNext(LoginResultBean loginResultBean) {
                TiPhoneLoginOutStreamHandler.getInstance().loginOutOnNext(loginResultBean);
            }
        });
    }

    private void hangup(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().hangup();
    }

    private void setOnEventListener(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().setOnEventListener(new OnEventListener() {
            @Override
            public void onError(String message) {
                TiPhoneSdkEventStreamHandler.getInstance().sdkErrorEvent(message);
            }

            @Override
            public void onEventChange(String event, String message) {
                TiPhoneSdkEventStreamHandler.getInstance().sdkEventChange(event, message);
            }

            @Override
            public void onDestroy() {
                TiPhoneSdkEventStreamHandler.getInstance().sdkOnDestroy();
            }
        });
    }

    @SuppressWarnings("ConstantConditions")
    private void sendDTMF(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().sendDTMF(
                call.argument("tones"),
                call.argument("duration"),
                call.argument("interToneGap")
        );
    }

    @SuppressWarnings("ConstantConditions")
    private void setMicrophoneMute(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().setMicrophoneMute(call.argument("muted"));
    }

    private void isSpeakerphoneEnabled(MethodCall call, MethodChannel.Result result) {
        result.success(
                TiPhone.getInstance().isSpeakerphoneEnabled()
        );
    }

    @SuppressWarnings("ConstantConditions")
    private void setEnableSpeakerphone(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().setEnableSpeakerphone(call.argument("enabled"));
    }


    private void getVersion(MethodCall call, MethodChannel.Result result) {
        result.success(
                TiPhone.getInstance().getVersion()
        );
    }

    @SuppressWarnings("ConstantConditions")
    private void setDebug(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().setDebug(call.argument("isDebug"));
    }

    @SuppressWarnings("ConstantConditions")
    private void setTelExplicit(MethodCall call, MethodChannel.Result result) {
        TiPhone.getInstance().setTelExplicit(call.argument("isTelExplicit"));
    }
}
