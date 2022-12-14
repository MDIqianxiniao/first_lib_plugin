#import "FlutterTiphonePlugin.h"
#import <TiPhoneSDK/TiPhoneSDK.h>
#import <WebRTC/WebRTC.h>
#import <TPhoneSDKCore/TPhoneSDKCore.h>
#import "Commons.h"

#import "FlutterTiPhoneEvent.h"

@interface FlutterTiphonePlugin ()
<
    TiOnEventListener,
    TiIncomingMessageListener,
    TiLoginMessageListener
>

@end

@implementation FlutterTiphonePlugin

FlutterTiPhoneEvent *loginEvent;
FlutterTiPhoneEvent *logoutEvent;
FlutterTiPhoneEvent *sdkEvent;
FlutterTiPhoneEvent *incomingEvent;
FlutterTiPhoneEvent *loginMessageEvent;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:MethodChannel_Name
            binaryMessenger:[registrar messenger]];
  FlutterTiphonePlugin* instance = [[FlutterTiphonePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    loginEvent = [[FlutterTiPhoneEvent alloc]initWithName:EventChannel_Login message:[registrar messenger]];
    logoutEvent = [[FlutterTiPhoneEvent alloc]initWithName:EventChannel_Logout message:[registrar messenger]];
    sdkEvent = [[FlutterTiPhoneEvent alloc]initWithName:EventChannel_SDK message:[registrar messenger]];
    incomingEvent = [[FlutterTiPhoneEvent alloc]initWithName:EventChannel_IncomingMessage message:[registrar messenger]];
    
    loginMessageEvent = [[FlutterTiPhoneEvent alloc]initWithName:EventChannel_IncomingMessage message:[registrar messenger]];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if ([@"init" isEqualToString:call.method])
  {
      NSDictionary *dict = call.arguments;
      NSString *platformUrl = dict[@"platformUrl"]?:@"";
      BOOL isDebug = [dict[@"isDebug"] boolValue];
      
      [[TiPhoneManager sharedTestManger] initSDK:platformUrl setDebug:isDebug];
  }
  else if ([method_loginTiPhone isEqualToString:call.method])
  {
      // ??????
      [self loginTiPhone:call result:result];
  }
//  else if ([method_loginTiPhoneByCrmId isEqualToString:call.method])
//  {
//      // ??????
//      [self loginTiPhone:call result:result];
//  }
//  else if ([method_loginTiPhoneByCno isEqualToString:call.method])
//  {
//      // ??????
//      [self loginTiPhone:call result:result];
//  }
  else if ([method_confirmVerificationCode isEqualToString:call.method])
  {
      // ?????????
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] confirmVerification:call.arguments[@"code"] success:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_call isEqualToString:call.method])
  {
      // ??????
      [self call:call result:result];
  }
  else if ([method_setIncomingMessageListener isEqualToString:call.method])
  {
      // ??????
      [[TiPhoneManager sharedTestManger] setIncomingMessageListener:self];
  }
  else if ([method_logoutTiPhone isEqualToString:call.method])
  {
      // ????????????
      [[TiPhoneManager sharedTestManger] logoutTiPhone:^(NSString * _Nullable data) {
          NSDictionary *dict = @{@"funName":@"onNext",@"code":@"200",@"message":@"????????????",@"cnoNum":@""};
          if(logoutEvent.eventSink)
          {
              logoutEvent.eventSink(dict);
          }
      } error:^(NSInteger code, NSString * _Nullable msg) {
          NSDictionary *dict = @{@"funName":@"onNext",@"code":[NSString stringWithFormat:@"%ld",code],@"message":msg?:@"????????????",@"cnoNum":@""};
          if(logoutEvent.eventSink)
          {
              logoutEvent.eventSink(dict);
          }
      }];
  }
  else if ([method_hangup isEqualToString:call.method])
  {
      // ??????
      [[TiPhoneManager sharedTestManger] hungUp];
  }
  else if ([method_setOnEventListener isEqualToString:call.method])
  {
      // ??????
      [[TiPhoneManager sharedTestManger] setOnEventListener:self];
  }
  else if ([method_sendDTMF isEqualToString:call.method])
  {
      // ????????????
      NSDictionary *dict = call.arguments;
      NSString *tones = dict[@"tones"]?:@"";
      int duration = [dict[@"duration"] intValue];
      int interToneGap = [dict[@"interToneGap"] intValue];
      
      [[TiPhoneManager sharedTestManger] sendDTMF:tones duration:duration interToneGap:interToneGap];
  }
  else if ([method_setMicrophoneMute isEqualToString:call.method])
  {
      // ?????????????????????
      NSDictionary *dict = call.arguments;
      BOOL muted = [dict[@"muted"] boolValue];
      
      [[TiPhoneManager sharedTestManger] setMicrophoneMute:muted];
  }
  else if ([method_isSpeakerphoneEnabled isEqualToString:call.method])
  {
      // ?????????????????????
      BOOL isSpeaker = [[TiPhoneManager sharedTestManger] isSpeakerphoneEnabled];
      result(@(isSpeaker));
  }
  else if ([method_setEnableSpeakerphone isEqualToString:call.method])
  {
      // ?????????????????????
      NSDictionary *dict = call.arguments;
      BOOL enabled = [dict[@"enabled"] boolValue];
      
      [[TiPhoneManager sharedTestManger] setEnableSpeakerphone:enabled];
  }
  else if ([method_getVersion isEqualToString:call.method])
  {
      // SDK?????????
      result([[TiPhoneManager sharedTestManger] getVersion]);
  }
//  else if ([method_setDebug isEqualToString:call.method])
//  {
//      // ??????????????????
//      NSDictionary *dict = call.arguments;
//      BOOL isDebug = [dict[@"isDebug"] boolValue];
//
//      [[TiPhoneManager sharedTestManger] setDebug:isDebug];
//  }
  else if ([method_setTelExplicit isEqualToString:call.method])
  {
      // ???????????????????????????????????????????????????
      NSDictionary *dict = call.arguments;
      BOOL isTelExplicit = [dict[@"isTelExplicit"] boolValue];
      
      [[TiPhoneManager sharedTestManger] setTelExplicit:isTelExplicit];
  }
  else if ([method_changePassword isEqualToString:call.method])
  {
      // ?????????????????? (??????????????????????????? token?????????????????????)
      NSDictionary *dict = call.arguments;
      NSString *oldPassword = dict[@"oldPassword"];
      NSString *newPassword = dict[@"newPassword"];
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] changePassword:oldPassword newPassword:newPassword success:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_previewOutCall isEqualToString:call.method])
  {
      // ????????????
      NSDictionary *dict = call.arguments;
      NSString *phoneNumber = dict[@"phoneNumber"];
      NSString *obClid = dict[@"obClid"];
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] previewOutCall:phoneNumber obClid:obClid success:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_getAgentSettings isEqualToString:call.method])
  {
      // ??????????????????????????????
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] getAgentSettings:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_getAgentStatus isEqualToString:call.method])
  {
      // ????????????????????????
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] getAgentStatus:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_setAgentPause isEqualToString:call.method])
  {
      // ????????????
      NSDictionary *dict = call.arguments;
      NSString *description = dict[@"description"];
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] setAgentPause:description success:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_setAgentUnPause isEqualToString:call.method])
  {
      // ????????????
      
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] setAgentUnPause:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_transferCall isEqualToString:call.method])
  {
      // Voip???????????????
      NSDictionary *dict = call.arguments;
      NSString *requestUniqueId = dict[@"requestUniqueId"];
      TIWeakSelf
      [[TiPhoneManager sharedTestManger] transferCall:requestUniqueId success:^(NSString * _Nullable data) {
          [weakSelf successBlock:data];
      } error:^(NSInteger code, NSString * _Nullable msg) {
          [weakSelf failedBlock:code message:msg];
      }];
  }
  else if ([method_webSocketDelegate isEqualToString:call.method])
  {
      // Voip???????????????
      [TiPhoneManager sharedTestManger].webSocketDelegate = self;
  }
  else
  {
    result(FlutterMethodNotImplemented);
  }
}


- (void)successBlock:(NSString *)dataString
{
    NSDictionary *dict = @{@"funName":@"onNext",@"message":@"",@"cnoNum":dataString?:@"",@"code":@"200"};
    
    if (loginEvent.eventSink)
    {
        loginEvent.eventSink(dict);
    }
}

- (void)failedBlock:(NSInteger)code message:(NSString *)msg
{
    NSDictionary *dict = @{@"funName":@"onNext",@"code":[NSString stringWithFormat:@"%ld",code],@"message":msg?:@"",@"cnoNum":@""};
    if (loginEvent.eventSink)
    {
        loginEvent.eventSink(dict);
    }
}



/// ??????
- (void)loginTiPhone:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSDictionary *dict = call.arguments;
    
//    NSString *strPlatformUrl = dict[@"strPlatformUrl"]?:@"";
    NSString *enterpriseId = dict[@"enterpriseId"]?:@"";
    TiPhoneLoginType loginType = [dict[@"loginType"] intValue];
    TiPhonePlatformType platformType = [dict[@"platformType"] intValue];
    NSString *loginKey = dict[@"loginKey"]?:@"";
    NSString *loginSecret = dict[@"loginSecret"]?:@"";
    NSString *bindTel = dict[@"bindTel"]?:@"";
    NSString *showName = dict[@"showName"]?:@"";
    BOOL isTelExplicit = [dict[@"isTelExplicit"] boolValue];
    NSDictionary *advanceParams = dict[@"advanceParams"];
    
    TIWeakSelf
    [[TiPhoneManager sharedTestManger] loginTiPhone:enterpriseId loginType:loginType platformType:platformType loginKey:loginKey loginSecret:loginSecret bindTel:bindTel showName:showName isTelExplicit:isTelExplicit advanceParams:advanceParams success:^(NSString * _Nullable data) {
        
        [weakSelf successBlock:data];

    } error:^(NSInteger code, NSString * _Nullable msg) {
        [weakSelf failedBlock:code message:msg];
    }];
}

/// ??????
- (void)call:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSDictionary *dict = call.arguments;
    
    NSString *phoneNumber = dict[@"phoneNumber"]?:@"";
    NSString *obClid = dict[@"obClid"]?:@"";
    NSString *requestUniqueId = dict[@"requestUniqueId"]?:@"";
    NSDictionary *userField = dict[@"userField"]?:@{};
    [[TiPhoneManager sharedTestManger] call:phoneNumber obClid:obClid requestUniqueId:requestUniqueId userField:userField];
}

#pragma mark - TiPhoneMessageListener
- (void)onPushMessage:(int)msgId withParam:(NSString *)param
{
    NSString *callState = [self adapterAndroidCallStates:msgId];
    
    NSDictionary *dict = @{@"funName":@"onEventChange",@"event":callState,@"message":param};

    if (sdkEvent.eventSink)
    {
        sdkEvent.eventSink(dict);
    }
}

#pragma mark - TiIncomingMessageListener
- (void)onIncomingMessage:(NSString *)param
{
    NSDictionary *dict = @{@"funName":@"onMessage",@"message":param};
    if (incomingEvent.eventSink)
    {
        incomingEvent.eventSink(dict);
    }
}

- (void)onKickout
{
    if (incomingEvent.eventSink)
    {
        incomingEvent.eventSink(@{@"funName":@"onKickout"});
    }
}

///  ??????iOS???Android???TiPhoneMessageListener?????????
- (NSString *)adapterAndroidCallStates:(int)msgId
{
    NSString *callState = @"";
    if (msgId == MESSAGE_REGISTERED)
    {
        callState = registered;
    }
    else if (msgId == MESSAGE_REGISTER_FAILED)
    {
        callState = registration_failed;
    }
    else if (msgId == MESSAGE_CALLING)
    {
        callState = calling;
    }
    else if (msgId == MESSAGE_ACCEPTED)
    {
        callState = accepted;
    }
    else if (msgId == MESSAGE_HANGUP)
    {
        callState = hangup;
    }
    else if (msgId == MESSAGE_RINGING)
    {
        callState = ringing;
    }
    else if (msgId == MESSAGE_PROGRESS)
    {
        callState = progress;
    }
    else if (msgId == MESSAGE_TRANSFER_CALL)
    {
        callState = transferCall;
    }
    else if (msgId == MESSAGE_PARAMS_COUNT_INCORRECT)
    {
        callState = paramsMountIncorrect;
    }
    else if (msgId == MESSAGE_PARAMS_KEYLENGTH_INCORRECT)
    {
        callState = paramsKeyIncorrect;
    }
    else if (msgId == MESSAGE_PARAMS_VALUELENGTH_INCORRECT)
    {
        callState = paramsValueIncorrect;
    }
    else if (msgId == MESSAGE_PARAMS_KEYUSED)
    {
        callState = paramsKeyUsed;
    }
    else if (msgId == MESSAGE_WAIT_LASTCALL)
    {
        callState = repeatCall;
    }
    else if (msgId == MESSAGE_REQUEST_UNIQUE_ID)
    {
        callState = paramRequestUniqueId;
    }
    else if (msgId == MESSAGE_RTC_QOS_GOOD)
    {
        callState = mediaStatQosGood;
    }
    else if (msgId == MESSAGE_RTC_QOS_BAD)
    {
        callState = mediaStatQosBad;
    }
    else if (msgId == MESSAGE_RTC_QOS_COMMON)
    {
        callState = mediaStatQosCommon;
    }
    else if (msgId == MESSAGE_ERROR || msgId == MESSAGE_NETPEER_CLOSED)
    {
        callState = netPeerClosed;
    }
    
    return callState;
}


@end
