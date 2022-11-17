//
//  TiPhone.h
//  TiPhoneSDK
//
//  Created by 马迪 on 2022/10/10.
//

#import <Foundation/Foundation.h>
#import <TiPhoneSDK/TiPhoneListener.h>
NS_ASSUME_NONNULL_BEGIN

// 登录账号类型
typedef enum : NSUInteger {
    TiPhoneLoginType_CrmIdAndPwd, // 员工和密码登录
    TiPhoneLoginType_CnoAndToken, // 坐席编号和token登录
} TiPhoneLoginType;

// 平台类型
typedef enum : NSUInteger {
    TiPhonePlatformType_CTI,
    TiPhonePlatformType_Clink2,
} TiPhonePlatformType;


@interface TiPhoneManager : NSObject


+ (instancetype)sharedTestManger;

/**
 初始化对象
 @param url 平台url
 @param setDebug 是否Debug环境
 */
- (void)initSDK:(nullable NSString *)url setDebug:(BOOL)setDebug;

/**
 座席上线接口
 @param enterpriseId 企业id
 @param loginType 登录类型 @"crmIdAndPwd" / @"conAndToken"
 @param platformType 平台类型
 @param loginKey 员工工号 / 座席工号
 @param loginSecret 员工密码 / 企业的token值
 @param bindTel 绑定的手机号码
 @param showName 系统内部显示名称
 @param isTelExplicit 是否需要手机号外显
 @param advanceParams 外部动态配置
 @param successBlock  登录成功的回调
 @param errorBlock   登录失败的回调 [status:失败的错误码]
 
 注: strCrmId和strCrmPassword是一对鉴权方式  strCno和strEnterpriseToken是一对鉴权方式
*/
- (void)loginTiPhone:(NSString *)enterpriseId loginType:(TiPhoneLoginType)loginType platformType:(TiPhonePlatformType)platformType loginKey:(NSString *)loginKey loginSecret:(NSString *)loginSecret  bindTel:(NSString *)bindTel showName:(nullable NSString *)showName isTelExplicit:(BOOL)isTelExplicit advanceParams:(NSDictionary *)advanceParams success:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 更新员工密码 (仅支持密码登录用户 token鉴权方式不支持)
 @param oldPassword 旧密码
 @param newPassword 新密码
 */
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 拨打电话
 @param number 需要拨打的手机号
 @param obClid 客户外显号码
 @param requestUniqueId 通话的唯一标识 如果传入为@"" 则sdk生成并在消息中返回所生成的唯一标识 P-Tinet-Request-Unique-Id
 @param userField 自定义参数  注:key/value 键值对最多支持5对，key小于20字节，value小于100字节
*/
-(void)call:(NSString * _Nonnull)number obClid:(NSString *) obClid
requestUniqueId:(NSString*)requestUniqueId userField:(NSDictionary *)userField;

/**
 设置回调接口(回调消息为拨打电话之后的消息) ， 必须在登录之前调用
 @param listener TiPhoneMessageListener接口的实例
 */
-(void)setOnEventListener:(id<TiOnEventListener>)listener;

/**
 设置回呼监听 需要在登录成功之后调用
@param listener TiIncomingMessageListener接口的实例
*/
-(void)setIncomingMessageListener:(id<TiIncomingMessageListener>)listener;

/**
 本地音频静音
 @param muted  发送本地音频流(false:默认发送本地音频流  true：发送本地静音音频流）
*/
-(void)setMicrophoneMute:(BOOL)muted;

/**
 检查扬声器是否开启
 @return true  扬声器已开启，语音会输出到扬声器
 @return false 扬声器未开启，语音会输出到听筒
*/
-(BOOL)isSpeakerphoneEnabled;

/**
 启用/关闭扬声器
 @param enabled 是否将音频外放(true：切换到外放  false：切换到听筒)
*/
-(void)setEnableSpeakerphone:(BOOL)enabled;

/**
 发送DTMF消息
 
 @param tones          所需要发送的DTMF消息.
 @param duration       消息时长 单位：秒
 @param interToneGap   消息间隔 单位：秒
*/
-(void)sendDTMF:(NSString *)tones duration:(NSTimeInterval)duration interToneGap:(NSTimeInterval)interToneGap;

/**
 挂断电话
 */
-(void)hungUp;

/// 退出登录
- (void)logoutTiPhone:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 认证语音验证码
 @param code 输入电话听到的语音验证码
 @param successBlock  成功的回调
 @param errorBlock   失败的回调 [status:失败的错误码]
 */
- (void)confirmVerification:(NSString *)code success:(TiSuccessCallback)successBlock error:(TiFailureCallback)errorBlock;

/**
 预览外呼
 @param phoneNumber 需要拨打的手机号
 @param obClid 客户外显号码
*/
- (void)previewOutCall:(NSString *)phoneNumber obClid:(nullable NSString *)obClid success:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 获取坐席置忙描述列表
 */
- (void)getAgentSettings:(TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 获取坐席当前状态
 */
- (void)getAgentStatus:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 坐席置忙
 @param description  设置的置忙描述 需要在获取坐席可用置忙描述列表中选择
 */
- (void)setAgentPause:(nullable NSString *)description success:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 坐席置闲
 */
- (void)setAgentUnPause:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 设置是否需要手机号外显
 */
- (void)setTelExplicit:(BOOL)isTelExplicit;

/**
 Voip转预览外呼
 @param requestUniqueId 通话的唯一标识 如果传入为@"" 则sdk生成并在消息中返回所生成的唯一标识 P-Tinet-Request-Unique-Id
*/
-(void)transferCall:(NSString *_Nonnull)requestUniqueId success:(nullable TiSuccessCallback)successBlock error:(nullable TiFailureCallback)errorBlock;

/**
 获取sdk版本号
 @return NSString* 版本号
*/
-(NSString *)getVersion;


/// 监听登录事件 Clink2专用
@property (nonatomic, weak) id <TiLoginMessageListener> webSocketDelegate;

@end

NS_ASSUME_NONNULL_END
