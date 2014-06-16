//
//  IptvChannelMode.h
//  WTV
//
//  Created by Gf_zgp on 14-3-17.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IptvChannelMode : NSObject
- (id)initIptvChannelModel:(NSString *)channelinfo;

@property (nonatomic,strong) NSString *ChannelID;
@property (nonatomic,strong) NSString *ChannelIgmpURL;
@property (nonatomic,strong) NSString *ChannelRtspURL;
@property (nonatomic,strong) NSString *ChannelBoxURL;
@property (nonatomic,strong) NSString *ChannelLogo;
@property (nonatomic,strong) NSString *ChannelName;
@property (nonatomic,strong) NSString *ServiceType;
@property (nonatomic,strong) NSString *ChannalPermit;

@end
