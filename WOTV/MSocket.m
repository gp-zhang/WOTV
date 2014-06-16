//
//  MSocket.m
//  AirPlay
//
//  Created by 幸芳 on 13-12-13.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MSocket.h"
__strong static MSocket *_sharedObject = nil;
__strong static MSocket *_sharedObjectExtra = nil;
__strong static MSocket *_shareCustom;

__strong static NSString *_statichost;
__strong static NSString *_staticport;

@implementation MSocket

+ (id)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject =  [[self alloc] init]; // or some other init metho
    });
    return _sharedObject;
}


+ (id)ShareWithHost:(NSString *)host Port:(NSString *)port
{
    if (_shareCustom == nil ) {
        _shareCustom = [[self alloc] init];
        _statichost = host;
        _staticport = port;
        
    }
    else if(![_statichost isEqualToString:host] || ![_staticport isEqualToString:port])
    {
        _statichost = host;
        _staticport = port;
    }
    return _shareCustom;
}


+ (id)shareWithExtra
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObjectExtra =  [[self alloc] init]; // or some other init metho
    });
    return _sharedObjectExtra;
}

- (void)ConnectionToHost:(NSString *) host onPort:(int)port withTimeout:(int) timeout error:(NSError *)errPtr ConnectBlock:(SocketDidConnected)Block
{
    self.socketConnectionBlock=Block;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    if (_SendSocket == nil) {
        _SendSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    }
    if ( ![_SendSocket isDisconnected]) {

        self.socketConnectionBlock(YES);
        return;
    }
    NSError *error;
    
    [_SendSocket connectToHost:host onPort:port withTimeout:timeout  error:&error];
    if (error) {
        NSLog(@"connecterror %@",error);
    }
}

- (void)sendMessage:(NSData *)msg Complete:(MessageSendComplete)complete
{
    self.messageComplete=complete;
//    message=msg;
    char *a = (char *)[msg bytes];
    
//    if ([_SendSocket isConnected]) {
//
//        [_SendSocket writeData:msg withTimeout:SocketTimeout tag:a[2]];
//    }
//    else
//    {
    [self ConnectionToHost:SocketDomain onPort:SocketPort withTimeout:SocketTimeout error:nil ConnectBlock:^(BOOL state) {
            if ([_SendSocket isConnected]) {
            }
            [_SendSocket writeData:msg withTimeout:SocketTimeout tag:a[2]];
            [_SendSocket readDataWithTimeout:-1 tag:0];
    }];
//    }
}
#pragma mark 发送推送相关命令
- (void)sendMessageWithExtra:(NSData *)msg Complete:(MessageSendComplete)complete
{
    self.messageComplete=complete;
    
    //    message=msg;
//    char *a = (char *)[msg bytes];
    [self ConnectionToHost:SocketExtraDomain onPort:SocketExtraPort withTimeout:SocketTimeout error:nil ConnectBlock:^(BOOL state) {
        if ([_SendSocket isConnected]) {
        }
        
        [_SendSocket writeData:msg withTimeout:SocketTimeout tag:0];

//        [self disconnect];
        
    }];
}


- (void)sendMessageWithCustom:(NSData *)msg Complete:(MessageSendComplete)complete
{
    self.messageComplete=complete;
    //    message=msg;
    char *a = (char *)[msg bytes];
    
    //    if ([_SendSocket isConnected]) {
    //
    //        [_SendSocket writeData:msg withTimeout:SocketTimeout tag:a[2]];
    //    }
    //    else
    //    {
    [self ConnectionToHost:_statichost onPort:[_staticport intValue] withTimeout:SocketTimeout error:nil ConnectBlock:^(BOOL state) {
        if ([_SendSocket isConnected]) {
        }
        [_SendSocket writeData:msg withTimeout:SocketTimeout tag:a[2]];
        [_SendSocket readDataWithTimeout:-1 tag:0];
    }];
    //    }
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.socketConnectionBlock(YES);
    NSLog(@"didconnection %f",[[NSDate date] timeIntervalSinceReferenceDate]);

}



- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    NSLog(@"超时");
    return 0;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didwritedatawithtag %ld",tag);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"disconnect %@ ",err);
    NSLog(@"disconnection %f",[[NSDate date] timeIntervalSinceReferenceDate]);

    _SendSocket = nil;

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    char *a = (char *)[data bytes];
    NSLog(@"readdata %d" ,a[0]);
    if (a[0]==0) {
        self.messageComplete(MessageStateSuccess,data);
    }
    else
    {
        self.messageComplete(MessageStateFail,data);
    }
    [self disconnect];

    if (self == _sharedObjectExtra) {
        [self disconnect];
    }
}


-(void)disconnect
{
    [_SendSocket disconnectAfterWriting];
}

@end
