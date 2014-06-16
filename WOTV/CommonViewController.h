//
//  CommonViewController.h
//  WOTV
//
//  Created by Gf_zgp on 14-6-13.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RevealBlock)();

@interface CommonViewController : UIViewController
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;

@end
