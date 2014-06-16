//
//  IptvChannelMode.m
//  WTV
//
//  Created by Gf_zgp on 14-3-17.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "IptvChannelMode.h"
#import "GDataXMLNode.h"
@implementation IptvChannelMode
@synthesize ChannelID,ChannelIgmpURL,ChannelBoxURL,ChannelRtspURL,ChannelLogo,ChannelName,ServiceType,ChannalPermit;
- (id)initIptvChannelModel:(NSString *)channelinfo
{
    self = [super init];
    if(self != nil)
    {
        NSError *error = nil;
        /*          <serviceType>TV</serviceType>
         <channelId>1</channelId>
         <name>CCTV-1</name>
         <permit>1</permit>
         <playUrl>/hls/CCTV-1.m3u8</playUrl>
         </ChannelSynopsisInfo>*/
        
        GDataXMLElement *info = [[GDataXMLElement alloc]initWithXMLString:channelinfo error:&error];
        if (!error) {
            
            GDataXMLElement *temp;
            temp = (GDataXMLElement *)[[info elementsForName:@"serviceType"] objectAtIndex:0];
            self.ChannelName = [temp stringValue];
            
            temp = (GDataXMLElement *)[[info elementsForName:@"channelId"] objectAtIndex:0];
            self.ChannelID = [temp stringValue];
            
            temp = (GDataXMLElement *)[[info elementsForName:@"name"] objectAtIndex:0];
            self.ChannelName = [temp stringValue];
            
            temp = (GDataXMLElement *)[[info elementsForName:@"playUrl"] objectAtIndex:0];
            self.ChannelBoxURL = [temp stringValue];
            
            temp = (GDataXMLElement *)[[info elementsForName:@"permit"] objectAtIndex:0];
            self.ChannelBoxURL = [temp stringValue];
            
        }
        else
        {
            NSLog(@"%@",error);
            return nil;
        }
    }
    return self;
}









@end
