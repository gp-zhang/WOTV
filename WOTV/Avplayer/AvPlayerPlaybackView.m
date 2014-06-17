//
//  AvPlayerPlaybackView.m
//  AirPlay
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AvPlayerPlaybackView.h"
#import <AVFoundation/AVFoundation.h>
@implementation AvPlayerPlaybackView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    return self;
//}

+ (Class)layerClass
{
	return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
	return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
    AVPlayerLayer *playerlayer=(AVPlayerLayer*)self.layer;
    [playerlayer setPlayer:player];
    player.allowsAirPlayVideo=YES;
//    player.usesAirPlayVideoWhileAirPlayScreenIsActive=YES;
}

/* Specifies how the video is displayed within a player layer’s bounds.
 (AVLayerVideoGravityResizeAspect is default) */
- (void)setVideoFillMode:(NSString *)fillMode
{
	AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
	playerLayer.videoGravity = fillMode;
}

- (id)initWithFrame:(CGRect)frame
{
    AvPlayerPlaybackView *shareobject;

//    if (shareobject == nil) {
        shareobject = [super initWithFrame:frame];
//    }
    return shareobject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
