//
//  MyDate.m
//  JXZ
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MyDate.h"

@implementation MyDate
+(NSString*)dateFormat:(int)time
{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps ;
    NSInteger unitFlags =NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
    comps=  [calendar components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MM月dd日"];
    if ([comps month]>0) {
        return [format stringFromDate:date];
    }
    else if ([comps day] >0) {
        if ([comps day] >3) {
            return [format stringFromDate:date];
        }
        return [NSString stringWithFormat:@"%d天前",[comps day]];
    }
    else if ([comps hour]>0) {
        return [NSString stringWithFormat:@"%d小时前",[comps hour]];
    }
    else if ([comps minute]>0) {
        return [NSString stringWithFormat:@"%d分钟前",[comps minute]];
    }
    else if ([comps second]>0) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    else
    {
        return @"NULL";
    }
}
+(NSString*)dateForString:(int)time
{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYY/MM/dd hh:mm"];
    return [format stringFromDate:date];
}

+(NSString*)IMGname:(NSDate*)date
{
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYYMMddkkmmssA"];
    return  [NSString stringWithFormat:@"%@.png",[format stringFromDate:date]];
    
}

@end
