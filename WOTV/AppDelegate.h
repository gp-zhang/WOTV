//
//  AppDelegate.h
//  WOTV
//
//  Created by Gf_zgp on 14-6-13.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasicUPnPDevice;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BasicUPnPDevice *mDevice;
+ (id)share;
@end
