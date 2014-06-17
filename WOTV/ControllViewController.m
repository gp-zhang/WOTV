//
//  ControllViewController.m
//  AirPlay
//
//  Created by 幸芳 on 13-12-16.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ControllViewController.h"
#import "MSocket.h"
#define keyboardHeight 216
#define barHeight 48


@interface ControllViewController ()
{
    int channel;
    int channelcount;
    NSMutableArray *socketArray;
    UIButton *MoreBtn;
    UIButton *titleBtn;
    BOOL canShow;
}
@end

@implementation ControllViewController
@synthesize channelArray,textBar,desAddress=_desAddress,desPort=_desPort;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upBtnPressed:)
                                                     name:@"upBtnPressed" object:nil];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_title_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setFrame:CGRectMake(0, 0, 100, 44)];
    [titleBtn addTarget:self action:@selector(TitleBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIImageView *triangleimageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleBtn.frame.size.width - 21, 0, 21, 44)];
    triangleimageView.image = [UIImage imageNamed:@"top_title_triangle_normal.png"];
    triangleimageView.highlightedImage = [UIImage imageNamed:@"top_title_triangle_on.png"];
    triangleimageView.highlighted = titleBtn.selected;
    triangleimageView.tag = 3001;
    triangleimageView.backgroundColor = [UIColor clearColor];
    triangleimageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
    
    
    UIImageView *sepreadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((titleBtn.frame.size.width)/2-7, titleBtn.frame.size.height - 8, 14, 8)];
    sepreadImageView.highlightedImage = [UIImage imageNamed:@"top_titile_spread_out_triangle.png"];
    
    sepreadImageView.highlighted = titleBtn.selected;
    sepreadImageView.tag = 3002;
    
    sepreadImageView.backgroundColor = [UIColor clearColor];
    sepreadImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [titleBtn addSubview:sepreadImageView];
    [titleBtn setTitle:@"遥控器" forState:UIControlStateNormal];
    [titleBtn setBackgroundColor:[UIColor clearColor]];
    
    [titleBtn addSubview:triangleimageView];
    
    self.navigationItem.titleView = titleBtn;
    
    
    MoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [MoreBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [MoreBtn setImage:[UIImage imageNamed:@"top_title_more_normal.png"] forState:UIControlStateNormal];
    [MoreBtn setImage:[UIImage imageNamed:@"top_title_more_on.png"] forState:UIControlStateSelected];
    [MoreBtn addTarget:self action:@selector(MoreBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *sepreadImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((MoreBtn.frame.size.width)/2-7, MoreBtn.frame.size.height - 8, 14, 8)];
    sepreadImageView2.highlightedImage = [UIImage imageNamed:@"top_titile_spread_out_triangle.png"];
    
    sepreadImageView2.highlighted = titleBtn.selected;
    sepreadImageView2.tag = 3002;
    sepreadImageView2.backgroundColor = [UIColor clearColor];
    sepreadImageView2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [MoreBtn addSubview:sepreadImageView2];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:MoreBtn], nil];
    
    channel=0;
    // Do any additional setup after loading the view from its nib.

    channelcount=[channelArray count];
    
    UIView *view = [self.view viewWithTag:233];
    [view setTransform:CGAffineTransformMakeRotation(M_PI/4)];
    [view.layer setCornerRadius:view.bounds.size.height/2];
    [view.layer setMasksToBounds:YES];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    
    //    self.numberPadView.frame = CGRectMake(self.numberPadView.frame.origin.x, -self.numberPadView.frame.size.height, self.numberPadView.frame.size.width, self.numberPadView.frame.size.height);
    
    self.moreView.frame = CGRectMake(self.moreView.frame.origin.x, -self.moreView.frame.size.height, self.moreView.frame.size.width, self.moreView.frame.size.height);
    
    self.menuView.frame = CGRectMake(self.menuView.frame.origin.x, -self.menuView.frame.size.height, self.menuView.frame.size.width, self.menuView.frame.size.height);
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.mInputView addGestureRecognizer:gesture];
    [self.mInputView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    textBar = [[KSBTextbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-barHeight, self.view.frame.size.width, barHeight)];
    textBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //    [textBar setMaxLine:4];
    [self.mInputView addSubview:textBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
}

- (void)TitleBtnSelected:(UIButton *)sender
{
    UIImageView *img1 = (UIImageView *)[titleBtn viewWithTag:3001];
    UIImageView *img2 = (UIImageView *)[titleBtn viewWithTag:3002];
    
    
    CGFloat dur=0;
    
    if (sender) {
        if (MoreBtn.selected  || !self.mInputView.hidden) {
            [self hiddenAll:self.menuView];
            
            return;
        }
        sender.selected = !sender.selected;
        img1.highlighted = sender.selected;
        img2.highlighted = sender.selected;
        dur = 0.25;
    }
    else
    {
        titleBtn.selected = NO;
        img1.highlighted = NO;
        img2.highlighted = NO;
    }
    
    CGFloat targetY=0;
    if (self.menuView.frame.origin.y<0) {
        targetY=0;
        self.menuView.frame = CGRectMake(self.menuView.frame.origin.x, -self.menuView.frame.size.height+80, self.menuView.frame.size.width, self.menuView.frame.size.height);
        
    }
    else
    {
        targetY = -self.menuView.frame.size.height;
    }
    [UIView animateWithDuration:dur animations:^{
        self.menuView.frame = CGRectMake(self.menuView.frame.origin.x, targetY, self.menuView.frame.size.width, self.menuView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)MoreBtnSelected:(UIButton *)sender
{
    UIImageView *img2 = (UIImageView *)[MoreBtn viewWithTag:3002];
    
    CGFloat dur=0;
    
    if (sender) {
        if (titleBtn.selected || !self.mInputView.hidden) {
            [self hiddenAll:self.moreView];
            
            return;
        }
        
        
        sender.selected = !sender.selected;
        img2.highlighted = sender.selected;
        dur = 0.25;
    }
    else
    {
        MoreBtn.selected = NO;
        img2.highlighted = NO;
    }
    
    CGFloat targetY=0;
    if (self.moreView.frame.origin.y<0) {
        targetY=0;
        self.moreView.frame = CGRectMake(self.moreView.frame.origin.x, -self.moreView.frame.size.height+80, self.moreView.frame.size.width, self.moreView.frame.size.height);
        
    }
    else
    {
        targetY = -self.moreView.frame.size.height;
    }
    [UIView animateWithDuration:dur animations:^{
        self.moreView.frame = CGRectMake(self.moreView.frame.origin.x, targetY, self.moreView.frame.size.width, self.moreView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hiddenAll:(id) sender
{
    if (self.mInputView.hidden == NO) {
        self.mInputView.hidden = YES;
        [textBar.tv resignFirstResponder];
    }
    
    
    if (MoreBtn.selected) {
        [self MoreBtnSelected:nil];
        
    }
    //
    if (titleBtn.selected) {
        
        [self TitleBtnSelected:nil];
        
    }
    
}

- (void)Popself:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Doinput:(id)sender
{
    [self hiddenAll:self.mInputView];
    
    self.mInputView.hidden = !self.mInputView.hidden;
    [textBar.tv becomeFirstResponder];
    if (self.mInputView.hidden) {
        [textBar.tv resignFirstResponder];
    }
}

- (IBAction)menuItemSelected:(id)sender {
    [self.numBtn setSelected:NO];
    [self.dirBtn setSelected:NO];
    [sender setSelected:YES];
    
    if (sender == self.numBtn) {
        [self ShownumPad:self.numBtn];
        [titleBtn setTitle:@"数字键" forState:UIControlStateNormal];
    }
    else if (sender == self.dirBtn)
    {
        [self showDirection:self.dirBtn];
        [titleBtn setTitle:@"方向键" forState:UIControlStateNormal];
    }
    [self TitleBtnSelected:nil];
}

- (IBAction)moreItemSelected:(id)sender {
    if (sender == self.minputBtn) {
        [self Doinput:self.minputBtn];
    }
}

- (IBAction)KeyDown:(id)sender {
}

- (IBAction)KeyUp:(id)sender {
    NSString *action=@"";
    switch ([sender tag]) {
        case 601:
            action = @"menu_up";
            break;
        case 602:
            action = @"menu_right";
            break;
        case 603:
            action = @"menu_down";
            break;
        case 604:
            action = @"menu_left";
            break;
        case 605:
            action = @"menu_ok";
            break;
//        case 713:
//            action = @"volumup";
//            break;
//        case 714:
//            action = @"volumdown";
//            break;
        default:
            break;
    }
    
    
    NSString *msg = [NSString stringWithFormat:@"%@:%@",action,action];
    
    [[MSocket ShareWithHost:_desAddress Port:self.desPort] sendMessageWithCustom:[msg dataUsingEncoding:NSUTF8StringEncoding] Complete:^(MessageState state, NSData *responsedata) {
        
    }];
    
    
//    [NetEngine createHttpActionWithUrlString:[NSString stringWithFormat:@"http://192.168.8.125:7766/remotecontrol?action=%@",action] params:nil onCompletion:^(id responseData, BOOL isCache, id redirectURL) {
//        
//    } onError:^(NSError *error) {
//        
//    } useCache:NO withMask:SVProgressHUDMaskTypeNil httpMethod:@"GET"];
    
}

- (IBAction)KeyUpOut:(id)sender {
}


- (void)upBtnPressed:(id)sender {
    if(textBar.tv.text.length == 0) {
        return;
    }
    
    textBar.tv.text = @"";
    [textBar makeDefaultState];
    
}

- (void)hideKeyboard:(id)sender {
    [textBar.tv resignFirstResponder];
    self.mInputView.hidden = YES;
}

- (void)keyboardWillShow:(NSNotification *)notif {
    
    NSDictionary *userInfo = [notif userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    
    [UIView beginAnimations:@"animateMoveToolbar" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [self.textBar setFrame:CGRectMake(0, self.mInputView.frame.size.height-keyboardRect.size.height-self.textBar.frame.size.height, self.textBar.frame.size.width, self.textBar.frame.size.height)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:@"animateMoveToolbar" context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.textBar setFrame:CGRectMake(0, self.mInputView.frame.size.height-self.textBar.frame.size.height, 320, self.textBar.frame.size.height)];
    [UIView commitAnimations];
}

- (void)ShownumPad:(id)sender
{
    
    CGFloat target=1;
    if (!self.numberPadView.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.numberPadView.alpha = target;
        self.numberPadView.hidden = !target;
    } completion:^(BOOL finished) {
        
    }];
}



- (void)showDirection:(id) sender
{
    CGFloat target=0;
    if (self.numberPadView.hidden) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.numberPadView.alpha = target;
        self.numberPadView.hidden = !target;
    } completion:^(BOOL finished) {
        
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChannelChange:(id)sender {
    //    NSString *str = [NSString stringWithFormat:@"play:%d",[sender tag]-1001];
    //    [[MSocket share] sendMessage:str Complete:^(MessageState state, NSString *responsedata) {
    //        UILabel *lable = (UILabel *)[self.view viewWithTag:1000];
    //        lable.text=responsedata;
    //    }];
}
- (IBAction)Menu:(id)sender {
//    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:0];
//    char senddata[4] = {0};
//    senddata[0]=CLIENTTYPE;
//    senddata[1]=COMMANDID;
//    senddata[3]=KEYVALUEMENU;
//    senddata[2]=KEYSTATUSDOWN;
//    [data appendBytes:senddata length:32];
//    [[MSocket share] sendMessage:data Complete:^(MessageState state, NSData *responsedata) {
//        if (state == MessageStateSuccess) {
//        }
//    }];
}
//
- (IBAction)Back:(id)sender {
//    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:0];
//    char senddata[4] = {0};
//    senddata[0]=CLIENTTYPE;
//    senddata[1]=COMMANDID;
//    senddata[3]=KEYVALUEBACK;
//    senddata[2]=KEYSTATUSDOWN;
//    [data appendBytes:senddata length:32];
//    [[MSocket share] sendMessage:data Complete:^(MessageState state, NSData *responsedata) {
//        if (state == MessageStateSuccess) {
//            DLog(@"recieve   sucess");
//        }
//    }];
}
//
- (IBAction)home:(id)sender {
    
    NSString *msg = [NSString stringWithFormat:@"menu_show:menu_show"];
    
    [[MSocket ShareWithHost:_desAddress Port:self.desPort] sendMessageWithCustom:[msg dataUsingEncoding:NSUTF8StringEncoding] Complete:^(MessageState state, NSData *responsedata) {
        
    }];
    
//    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:0];
//    char senddata[4] = {0};
//    senddata[0]=CLIENTTYPE;
//    senddata[1]=COMMANDID;
//    senddata[3]=KEYVALUEHOME;
//    senddata[2]=KEYSTATUSDOWN;
//    [data appendBytes:senddata length:32];
//    [[MSocket share] sendMessage:data Complete:^(MessageState state, NSData *responsedata) {
//        if (state == MessageStateSuccess) {
//            
//        }
//    }];
}
//
- (IBAction)tuisong:(id)sender {
//    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:0];
//    char senddata[4] = {0};
//    
//    senddata[0]=CLIENTTYPE;
//    senddata[1]=COMMANDID;
//    senddata[3]=0x09;
//    senddata[2]=KEYSTATUSDOWN;
//    [data appendBytes:senddata length:32];
//    [[MSocket share] sendMessage:data Complete:^(MessageState state, NSData *responsedata) {
//        if (state == MessageStateSuccess) {
//        }
//    }];
}
@end
