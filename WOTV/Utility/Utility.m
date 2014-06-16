//
//  Utility.m
//  CloudTravel
//
//  Created by hetao on 10-12-5.
//  Copyright 2010 oulin. All rights reserved.
//

#import "Utility.h"
//#import "NSDictionaryCategory.h"
//#import "ShowTips.h"
#define picMidWidth 200
#define picSmallWidth 100
@interface Utility (){
    UITextField *accountField,*passField;
    NSString *phoneNum;
}
@property (nonatomic,copy) void (^finished)(NSString *account,NSString *pass);
@end

@implementation Utility

static Utility *_instance=nil;

+(id)Share
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        _instance = [[Utility alloc] init];
    });
	return _instance;
}
#pragma mark -
#pragma mark makeCall
- (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
    return [[[[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]
									stringByReplacingOccurrencesOfString:@"-" withString:@""]
										stringByReplacingOccurrencesOfString:@"(" withString:@""] 
											stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    //return number1;    
}

#pragma mark -
#pragma mark getAddressBy
-(NSString *)getAddressBy:(NSString *)description{
	NSArray *strArray = [description componentsSeparatedByString:@" "];
	
	return [strArray objectAtIndex:1];
}

#pragma mark -
#pragma mark validateEmail
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}
#pragma mark validateTel
- (BOOL) validateTel: (NSString *) candidate {
    NSString *telRegex = @"^1[358]\\d{9}$"; 
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex]; 
	
    return [telTest evaluateWithObject:candidate];
}
#pragma ImagePeSize
-(CGFloat)percentage:(NSString*)per width:(NSInteger)width
{
    if (per) { 
        NSArray *stringArray = [per componentsSeparatedByString:@"*"];
        
        if ([stringArray count]==2) {
            CGFloat w=[[stringArray objectAtIndex:0] floatValue];
            CGFloat h=[[stringArray objectAtIndex:1] floatValue];
            if (w>=width) {
                return h*width/w;
            }else{
                return  h;
            }
        }
    }
    return width;
}

//判断ios版本AVAILABLE
- (BOOL)isAvailableIOS:(CGFloat)availableVersion
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=availableVersion) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark TimeTravel
- (NSString*)timeStart:(NSString*)theDate end:(NSString*)endDate 
{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    if([d compare:[NSDate date]] == NSOrderedDescending){
        return @"即将开启";
//        d=[dateFormatter dateFromString:endDate];
//        NSTimeInterval cha=[d timeIntervalSinceNow]/(3600*24)+0.5;
//        return [NSString stringWithFormat:@"%.0f天",cha<0?-cha:cha];
    }else {
        d=[dateFormatter dateFromString:endDate];
        NSTimeInterval cha=([d timeIntervalSinceNow]/(3600*24))+0.5;
        return [NSString stringWithFormat:@"%.0f天",cha<0?-cha:cha];
    }
}
- (NSString*)timeToNow:(NSString*)theDate needYear:(BOOL)needYear
{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateOfCurrentString = [dateFormatter stringFromDate:d];
    NSString *dateOfYesterdayString = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]];
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }else if (cha/3600>1 && [todayString isEqualToString:dateOfCurrentString]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeString = [dateFormatter stringFromDate:d];
        timeString=[NSString stringWithFormat:@"今天%@", timeString];
    }else if ([dateOfCurrentString isEqualToString:dateOfYesterdayString]){
        [dateFormatter setDateFormat:@"HH:mm"];
        timeString = [dateFormatter stringFromDate:d];
        timeString=[NSString stringWithFormat:@"昨天%@", timeString];
    }
    else
    {
        if (needYear) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        else
        {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        }
        timeString=[dateFormatter stringFromDate:d];
    }
    
    return timeString;
}

- (NSString *)timeyyyMMdd:(NSString*)theDate
{
    //DLog(@"theDate: %@",theDate);
    if (!theDate) {
        return @"";
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];        
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:theDate];
    
    if (!date) {
        return theDate;
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    if (timeString) {
        return timeString;  
    }
    
    return theDate;
}

- (NSString *)timeToWeekMMdd:(NSString *)theDate
{
    //DLog(@"theDate: %@",theDate);
    if (!theDate) {
        return @"";
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];        
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:theDate];
    
    if (!date) {
        return theDate;
    }
    
    [dateFormatter setDateFormat:@"EEE MMM d"];
    
    
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    if (timeString) {
        return timeString;  
    }
    
    return theDate;
}

- (NSString *)timeToMMddHHmm:(NSString *)theDate
{
    //DLog(@"theDate: %@",theDate);
    if (!theDate) {
        return @"";
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];        
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:theDate];
    
    if (!date) {
        return theDate;
    }
    
    [dateFormatter setDateFormat:@"MMM d HH:mm"];
    
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    if (timeString) {
        return timeString;  
    }
    
    return theDate;
}

- (NSString*)birthToNow:(NSString*)theDate
{
    if (!theDate||[theDate intValue]==0) {
        return @"25岁";
    }
    //NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    //[dateFormatter setLocale:[NSLocale currentLocale]];        
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];    
    NSDate * date = [NSDate date];
    //NSString * currentYear = [dateFormatter stringFromDate:date];
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    
    NSInteger year = [components year];
    NSInteger nowAge = year - [theDate intValue];//textF是输入生日的文本框
    //DLog(@"current year:%@", currentYear);
    NSLog(@"age:%i", nowAge);
    return [NSString stringWithFormat:@"%d岁",nowAge<1?25:nowAge>99?99:nowAge];
}

//来自端
- (NSString *)platformWithType:(NSString *)type;
{
    if ([type isEqual:@"1"]) {
        return @"来自iPhone";
    }
    else if([type isEqual:@"2"])
    {
        return @"来自Android";
    }
    else if([type isEqual:@"3"])
    {
        return @"来自网页";
    }
    else
        return @"来自火星";
}


-(void)showLoginAlert:(void(^)(NSString *account,NSString *pass))afinished
{
    self.finished=afinished;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登录"
                                                  message:@"\n\n\n"
                                                 delegate:self
                                        cancelButtonTitle:@"注册"
                                        otherButtonTitles:@"登录", nil];
    UIButton *close=[[UIButton alloc] initWithFrame:CGRectMake(230, 5, 30, 30)];
    [close addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [close setTitle:@"X" forState:UIControlStateNormal];
    
    
    accountField=[[UITextField alloc] initWithFrame:CGRectMake(20, 40, 240, 31)];
    accountField.borderStyle=UITextBorderStyleRoundedRect;
    accountField.keyboardType=UIKeyboardTypeNumberPad;
    accountField.placeholder=@"手机号码";
    [accountField becomeFirstResponder];
    passField=[[UITextField alloc] initWithFrame:CGRectMake(20, 73, 240, 31)];  
    passField.borderStyle=UITextBorderStyleRoundedRect;
    passField.placeholder=@"密码";
    passField.keyboardType=UIKeyboardTypeDefault;
    passField.secureTextEntry=YES;
    
    //passField.autoresizingMask  = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;//accountField.autoresizingMask = logo.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [alert addSubview:passField];
    [alert addSubview:accountField];
    [alert addSubview:close];

    [alert show];

    
}
-(IBAction)closeButtonClicked:(id)sender
{
    [(UIAlertView*)[sender superview] dismissWithClickedButtonIndex:10 animated:YES];
}

@end
