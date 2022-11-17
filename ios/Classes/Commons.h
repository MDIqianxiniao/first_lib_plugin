//
//  Commons.h
//  Pods
//
//  Created by 马迪 on 2022/10/31.
//

#ifndef Commons_h
#define Commons_h

#define TIWeakSelf                  __weak __typeof(self) weakSelf = self;

static NSString * const method_init = @"init";

static NSString * const method_loginTiPhone = @"loginTiPhone";

//static NSString * const method_loginTiPhoneByCrmId = @"loginTiPhoneByCrmId";
//
//static NSString * const method_loginTiPhoneByCno = @"loginTiPhoneByCno";

static NSString * const method_confirmVerificationCode = @"confirmVerificationCode";

static NSString * const method_call = @"call";

static NSString * const method_setIncomingMessageListener = @"setIncomingMessageListener";

static NSString * const method_logoutTiPhone = @"loginOutTiPhone";

static NSString * const method_hangup = @"hangup";

static NSString * const method_setOnEventListener = @"setOnEventListener";

static NSString * const method_sendDTMF = @"sendDTMF";

static NSString * const method_setMicrophoneMute = @"setMicrophoneMute";

static NSString * const method_isSpeakerphoneEnabled = @"isSpeakerphoneEnabled";

static NSString * const method_setEnableSpeakerphone = @"setEnableSpeakerphone";

static NSString * const method_getVersion = @"getVersion";

// static NSString * const method_setDebug = @"setDebug";

static NSString * const method_setTelExplicit = @"setTelExplicit";

// NEW
static NSString * const method_changePassword = @"changePassword";

static NSString * const method_previewOutCall = @"previewOutCall";

static NSString * const method_getAgentSettings = @"getAgentSettings";

static NSString * const method_getAgentStatus = @"getAgentStatus";

static NSString * const method_setAgentPause = @"setAgentPause";

static NSString * const method_setAgentUnPause = @"setAgentUnPause";

static NSString * const method_transferCall = @"transferCall";

static NSString * const method_webSocketDelegate = @"webSocketDelegate";




// MethodChannel Name
static NSString * const MethodChannel_Name = @"method_channel/tiphone";

// EventChannel Name
static NSString * const EventChannel_Login = @"event_channel/tiphone/login_event";

static NSString * const EventChannel_Logout = @"event_channel/tiphone/login_out_event";

static NSString * const EventChannel_SDK = @"event_channel/tiphone/sdk_event";

static NSString * const EventChannel_IncomingMessage = @"event_channel/tiphone/incoming_message_event";


// CallStatus
static NSString * const registering = @"registering";
static NSString * const registered = @"registered";
static NSString * const calling = @"calling";
static NSString * const ringing = @"ringing";
static NSString * const proceeding = @"proceeding";
static NSString * const accepted = @"accepted";
static NSString * const progress = @"progress";
static NSString * const hangingup = @"hangingup";
static NSString * const hangup = @"hangup";
static NSString * const registration_failed = @"registration_failed";
static NSString * const configuration = @"configuration";
static NSString * const paramsKeyIncorrect = @"paramsKeyIncorrect";
static NSString * const paramsValueIncorrect = @"paramsValueIncorrect";
static NSString * const paramsMountIncorrect = @"paramsMountIncorrect";
static NSString * const paramsKeyUsed = @"paramsKeyUsed";
static NSString * const paramRequestUniqueId = @"paramRequestUniqueId";
static NSString * const repeatCall = @"repeatCall";
static NSString * const mediaStatInfo = @"mediaStatInfo";
static NSString * const mediaStatQosGood = @"mediaStatQosGood";
static NSString * const mediaStatQosBad = @"mediaStatQosBad";
static NSString * const mediaStatQosCommon = @"mediaStatQosCommon";
static NSString * const createdSession = @"createdSession";
static NSString * const keepAliveTime = @"keepAliveTime";
static NSString * const netIOFailed = @"netIOFailed";
static NSString * const netIOFailedReport = @"netIOFailedReport";
static NSString * const netPeerClosed = @"netPeerClosed";
static NSString * const socketException = @"socketException";
static NSString * const callGetAXBError = @"callGetAXBError";
//弹窗eventName:transferCall    description: "network_weak","registration_failed"
static NSString * const transferCall = @"transferCall";

#endif /* Commons_h */
