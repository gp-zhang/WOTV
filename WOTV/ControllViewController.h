//
//  ControllViewController.h
//  AirPlay
//
//  Created by 幸芳 on 13-12-16.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSBTextbar.h"
@interface ControllViewController : CommonViewController
@property (nonatomic, strong) KSBTextbar *textBar;
@property (nonatomic,strong) NSArray *channelArray;
@property (weak, nonatomic) IBOutlet UIView *mInputView;
@property (weak, nonatomic) IBOutlet UIView *numberPadView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *directionViw;
@property (weak, nonatomic) IBOutlet UIButton *dirBtn;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
@property (weak, nonatomic) IBOutlet UIButton *minputBtn;
@property (weak, nonatomic) IBOutlet UIButton *shutDownBtn;
@property (strong,nonatomic) NSString *desAddress;
@property (strong,nonatomic) NSString *desPort;

- (IBAction)Menu:(id)sender;
- (IBAction)Back:(id)sender;
- (IBAction)home:(id)sender;
- (IBAction)tapInputView:(id)sender;
- (IBAction)menuItemSelected:(id)sender;
- (IBAction)moreItemSelected:(id)sender;
- (IBAction)KeyDown:(id)sender;
- (IBAction)KeyUp:(id)sender;
- (IBAction)KeyUpOut:(id)sender;

@end
