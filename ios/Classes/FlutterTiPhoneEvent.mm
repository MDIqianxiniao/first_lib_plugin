//
//  FlutterTiPhoneEvent.m
//  flutter_tiphone_plugin
//
//  Created by 马迪 on 2022/11/2.
//

#import "FlutterTiPhoneEvent.h"

@implementation FlutterTiPhoneEvent

- (instancetype)initWithName:(NSString*)name message:(NSObject<FlutterBinaryMessenger>*)message
{
    if (self = [super init])
    {
        self.eventChannel = [FlutterEventChannel eventChannelWithName:name binaryMessenger:message];
        
        [self.eventChannel setStreamHandler:self];
    }
    return self;
}

- (FlutterError *)onCancelWithArguments:(id)arguments
{
    self.eventSink = nil;
    return nil;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(nonnull FlutterEventSink)events
{
    self.eventSink = events;
    return nil;
}


@end
