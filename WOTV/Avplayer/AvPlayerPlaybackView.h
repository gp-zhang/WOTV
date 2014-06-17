//
//  AvPlayerPlaybackView.h
//  AirPlay
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;
@interface AvPlayerPlaybackView : UIView
@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;
@end
