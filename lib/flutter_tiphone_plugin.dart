import 'package:flutter/services.dart';

class TiPhone {
  static final TiPhone _tiPhone = TiPhone._getInstance();

  static const MethodChannel _methodChannel =
      MethodChannel("method_channel/tiphone");
  static const EventChannel _loginEventChannel =
      EventChannel("event_channel/tiphone/login_event");
  static const EventChannel _loginOutEventChannel =
      EventChannel("event_channel/tiphone/login_out_event");
  static const EventChannel _sdkEventChannel =
      EventChannel("event_channel/tiphone/sdk_event");

  static const EventChannel _incomingMessageEventChannel =
      EventChannel("event_channel/tiphone/incoming_message_event");

  TiPhoneManagerCallbacks? _loginCallback = null;

  TiPhoneManagerCallbacks? _loginOutCallback = null;

  IIncomingMessageListener? _incomingMessageListener = null;

  OnEventListener? _onEventListener = null;

  factory TiPhone() => _tiPhone;

  TiPhone._getInstance() {
    _loginEventChannel.receiveBroadcastStream().listen(_loginEventDistribute);
    _loginOutEventChannel
        .receiveBroadcastStream()
        .listen(_loginOutEventDistribute);
    _sdkEventChannel.receiveBroadcastStream().listen(_sdkEventDistribute);
    _incomingMessageEventChannel
        .receiveBroadcastStream()
        .listen(_incomingMessageDistribute);
  }

  _loginEventDistribute(dynamic event) {
    switch (event["funName"]) {
      case "onError":
        _loginCallback?.onError(event["message"]);
        break;
      case "onNext":
        _loginCallback?.onNext(LoginResultBean(
            int.parse(event["code"]), event["message"],
            cnoNum: event["cnoNum"]));
        break;
    }
  }

  _loginOutEventDistribute(dynamic event) {
    switch (event["funName"]) {
      case "onError":
        _loginOutCallback?.onError(event["message"]);
        break;
      case "onNext":
        _loginOutCallback?.onNext(LoginResultBean(
            int.parse(event["code"]), event["message"],
            cnoNum: event["cnoNum"]));
        break;
    }
  }

  _sdkEventDistribute(dynamic event) {
    switch (event["funName"]) {
      case "onError":
        _onEventListener?.onError(event["message"]);
        break;
      case "onDestroy":
        _onEventListener?.onDestroy();
        break;

      case "onEventChange":
        _onEventListener?.onEventChange(event["event"], event["message"]);
        break;
    }
  }

  _incomingMessageDistribute(dynamic event) {
    switch (event["funName"]) {
      case "onMessage":
        _incomingMessageListener?.onMessage(event["message"]);
        break;
      case "onError":
        _incomingMessageListener?.onError(event["message"]);
        break;
      case "onKickout":
        _incomingMessageListener?.onKickout();
        break;
    }
  }

  Future<String?> getPlatformVersion() async {
    // return NewFlutterPlatform.instance.getPlatformVersion();
    return await _methodChannel.invokeMethod('getPlatformVersion');
  }

  init() async {
    await _methodChannel.invokeMethod(TiPhoneMethod.method_init);
  }

  setOnEventListener(OnEventListener listener) async {
    _onEventListener = listener;
    await _methodChannel.invokeMethod(TiPhoneMethod.method_setOnEventListener);
  }

  loginTiPhoneByCrmId(
    TiPhoneManagerCallbacks callbacks, {
    required String strPlatformUrl,
    required String enterpriseId,
    required String crmId,
    required String password,
    required String bindTel,
    required String showName,
    required bool isTelExplicit,
  }) async {
    _loginCallback = callbacks;
    await _methodChannel.invokeMethod(
        TiPhoneMethod.method_loginTiPhoneByCrmId, <String, dynamic>{
      "strPlatformUrl": strPlatformUrl,
      "enterpriseId": enterpriseId,
      "crmId": crmId,
      "password": password,
      "bindTel": bindTel,
      "showName": showName,
      "isTelExplicit": isTelExplicit
    });
  }

  loginTiPhoneByCno(
    TiPhoneManagerCallbacks callbacks, {
    required String strPlatformUrl,
    required String enterpriseId,
    required String crmId,
    required String password,
    required String cno,
    required String token,
    required String bindTel,
    required String showName,
    required bool isTelExplicit,
  }) async {
    _loginCallback = callbacks;
    await _methodChannel
        .invokeMethod(TiPhoneMethod.method_loginTiPhoneByCno, <String, dynamic>{
      "strPlatformUrl": strPlatformUrl,
      "enterpriseId": enterpriseId,
      "crmId": crmId,
      "password": password,
      "cno": cno,
      "token": token,
      "bindTel": bindTel,
      "showName": showName,
      "isTelExplicit": isTelExplicit
    });
  }

  confirmVerificationCode(String code) async {
    await _methodChannel.invokeMethod(
        TiPhoneMethod.method_confirmVerificationCode,
        <String, dynamic>{"code": code});
  }

  loginOutTiPhone(TiPhoneManagerCallbacks callbacks) async {
    _loginOutCallback = callbacks;
    await _methodChannel.invokeMethod(TiPhoneMethod.method_loginOutTiPhone);
  }

  call(
      {required String phoneNumber,
      required String obClid,
      required String requestUniqueId,
      required Map<String, String> userField}) async {
    await _methodChannel
        .invokeMethod(TiPhoneMethod.method_call, <String, dynamic>{
      "phoneNumber": phoneNumber,
      "obClid": obClid,
      "requestUniqueId": requestUniqueId,
      "userField": userField
    });
  }

  setIncomingMessageListener(IIncomingMessageListener listener) async {
    _incomingMessageListener = listener;
    await _methodChannel
        .invokeMethod(TiPhoneMethod.method_setIncomingMessageListener);
  }

  hangup() async {
    await _methodChannel.invokeMethod(TiPhoneMethod.method_hangup);
  }

  sendDTMF(
      {required String tones,
      required int duration,
      required int interToneGap}) async {
    await _methodChannel.invokeMethod(
        TiPhoneMethod.method_sendDTMF, <String, dynamic>{
      "tones": tones,
      "duration": duration,
      "interToneGap": interToneGap
    });
  }

  setMicrophoneMute(bool muted) async {
    await _methodChannel.invokeMethod(TiPhoneMethod.method_setMicrophoneMute,
        <String, dynamic>{"muted": muted});
  }

  Future<bool> isSpeakerphoneEnabled() async {
    return await _methodChannel
        .invokeMethod(TiPhoneMethod.method_isSpeakerphoneEnabled);
  }

  setEnableSpeakerphone(bool enabled) async {
    await _methodChannel.invokeMethod(
        TiPhoneMethod.method_setEnableSpeakerphone,
        <String, dynamic>{"enabled": enabled});
  }

  Future<String> getVersion() async {
    return await _methodChannel.invokeMethod(TiPhoneMethod.method_getVersion);
  }

  setDebug(bool isDebug) async {
    await _methodChannel.invokeMethod(
        TiPhoneMethod.method_setDebug, <String, dynamic>{"isDebug": isDebug});
  }

  setTelExplicit(bool isTelExplicit) async {
    await _methodChannel.invokeMethod(TiPhoneMethod.method_setTelExplicit,
        <String, dynamic>{"isTelExplicit": isTelExplicit});
  }
}

class TiPhoneMethod {
  static const String method_init = "init";
  static const String method_loginTiPhoneByCrmId = "loginTiPhoneByCrmId";
  static const String method_loginTiPhoneByCno = "loginTiPhoneByCno";
  static const String method_confirmVerificationCode =
      "confirmVerificationCode";
  static const String method_call = "call";
  static const String method_setIncomingMessageListener =
      "setIncomingMessageListener";
  static const String method_loginOutTiPhone = "loginOutTiPhone";
  static const String method_hangup = "hangup";
  static const String method_setOnEventListener = "setOnEventListener";
  static const String method_sendDTMF = "sendDTMF";
  static const String method_setMicrophoneMute = "setMicrophoneMute";
  static const String method_isSpeakerphoneEnabled = "isSpeakerphoneEnabled";
  static const String method_setEnableSpeakerphone = "setEnableSpeakerphone";
  static const String method_getVersion = "getVersion";
  static const String method_setDebug = "setDebug";
  static const String method_setTelExplicit = "setTelExplicit";
}

class TiPhoneManagerCallbacks {
  const TiPhoneManagerCallbacks(this.onError, this.onNext);

  final void Function(String? message) onError;

  final void Function(LoginResultBean? result) onNext;
}

class LoginResultBean {
  int code;
  String message = "";
  String cnoNum;

  LoginResultBean(this.code, this.message, {this.cnoNum = ""});
}

class IIncomingMessageListener {
  const IIncomingMessageListener(this.onMessage, this.onError, this.onKickout);

  final void Function(String? message) onMessage;

  final void Function(String? errorMsg) onError;

  final void Function() onKickout;
}

class OnEventListener {
  OnEventListener(this.onError, this.onEventChange, this.onDestroy);

  void Function(String? message) onError;

  void Function(String? event, String? message) onEventChange;

  void Function() onDestroy;
}

class CallStatus {
  CallStatus._();

  static const String registering = "registering";
  static const String registered = "registered";
  static const String calling = "calling";
  static const String ringing = "ringing";
  static const String proceeding = "proceeding";
  static const String accepted = "accepted";
  static const String progress = "progress";
  static const String hangingup = "hangingup";
  static const String hangup = "hangup";
  static const String registration_failed = "registration_failed";
  static const String configuration = "configuration";
  static const String paramsKeyIncorrect = "paramsKeyIncorrect";
  static const String paramsValueIncorrect = "paramsValueIncorrect";
  static const String paramsMountIncorrect = "paramsMountIncorrect";
  static const String paramsKeyUsed = "paramsKeyUsed";
  static const String paramRequestUniqueId = "paramRequestUniqueId";
  static const String repeatCall = "repeatCall";
  static const String mediaStatInfo = "mediaStatInfo";
  static const String mediaStatQosGood = "mediaStatQosGood";
  static const String mediaStatQosBad = "mediaStatQosBad";
  static const String mediaStatQosCommon = "mediaStatQosCommon";
  static const String createdSession = "createdSession";
  static const String keepAliveTime = "keepAliveTime";
  static const String netIOFailed = "netIOFailed";
  static const String netIOFailedReport = "netIOFailedReport";
  static const String netPeerClosed = "netPeerClosed";
  static const String socketException = "socketException";
  static const String callGetAXBError = "callGetAXBError";
  //弹窗eventName:transferCall    description: "network_weak","registration_failed"
  static const String transferCall = "transferCall";
}
