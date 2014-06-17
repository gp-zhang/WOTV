//
//  LiveDetailViewController.h
//  WOTV
//
//  Created by Gf_zgp on 14-6-17.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "AvplayerPlaybackViewController.h"
@class IptvChannelMode;
@interface LiveDetailViewController : AvplayerPlaybackViewController
@property (strong,nonatomic) IptvChannelMode *mChannel;
@end
