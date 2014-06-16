//
//  MSocket.h
//  AirPlay
//
//  Created by 幸芳 on 13-12-13.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
typedef enum{
    MessageStateSuccess,
    MessageStateFail,
    MessageStateCancle
}MessageState;
typedef void (^MessageSendComplete)(MessageState state,NSData *responsedata);
typedef void (^SocketDidConnected) (BOOL state);
@interface MSocket : NSObject<GCDAsyncSocketDelegate>
{
    NSString *message;
}
@property (nonatomic,strong)MessageSendComplete messageComplete;
@property (nonatomic,strong)SocketDidConnected socketConnectionBlock;
@property (nonatomic,strong)GCDAsyncSocket *SendSocket;

+ (id)share;
+ (id)shareWithExtra;
+ (id)ShareWithHost:(NSString *)host Port:(NSString *)port;


- (void)sendMessage:(NSData *)msg Complete:(MessageSendComplete)complete;
- (void)sendMessageWithExtra:(NSData *)msg Complete:(MessageSendComplete)complete;
- (void)sendMessageWithCustom:(NSData *)msg Complete:(MessageSendComplete)complete;

- (void)disconnect;


@end
