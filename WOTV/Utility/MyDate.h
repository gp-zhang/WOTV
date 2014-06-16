//
//  MyDate.h
//  JXZ
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDate : NSObject
+(NSString*)dateFormat:(int)time;
+(NSString*)dateForString:(int)time;
+(NSString*)IMGname:(NSDate*)date;
@end
