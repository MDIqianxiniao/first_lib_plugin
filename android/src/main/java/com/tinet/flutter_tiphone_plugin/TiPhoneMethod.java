package com.tinet.flutter_tiphone_plugin;

public interface TiPhoneMethod {
    String method_init = "init";
    String method_loginTiPhoneByCrmId = "loginTiPhoneByCrmId";
    String method_loginTiPhoneByCno = "loginTiPhoneByCno";
    String method_confirmVerificationCode = "confirmVerificationCode";
    String method_call = "call";
    String method_setIncomingMessageListener = "setIncomingMessageListener";
    String method_loginOutTiPhone = "loginOutTiPhone";
    String method_hangup = "hangup";
    String method_setOnEventListener = "setOnEventListener";
    String method_sendDTMF = "sendDTMF";
    String method_setMicrophoneMute = "setMicrophoneMute";
    String method_isSpeakerphoneEnabled = "isSpeakerphoneEnabled";
    String method_setEnableSpeakerphone = "setEnableSpeakerphone";
    String method_getVersion = "getVersion";
    String method_setDebug = "setDebug";
    String method_setTelExplicit = "setTelExplicit";
}
