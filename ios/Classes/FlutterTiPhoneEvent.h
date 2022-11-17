//
//  FlutterTiPhoneEvent.h
//  flutter_tiphone_plugin
//
//  Created by 马迪 on 2022/11/2.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterTiPhoneEvent : NSObject<FlutterStreamHandler>

@property (nonatomic, strong) FlutterEventChannel *eventChannel;

@property (nonatomic, strong, nullable) FlutterEventSink eventSink;

- (instancetype)initWithName:(NSString*)name message:(NSObject<FlutterBinaryMessenger>*)message;

@end

NS_ASSUME_NONNULL_END
