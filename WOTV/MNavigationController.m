//
//  MNavigationController.m
//  JC
//
//  Created by user on 13-8-31.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MNavigationController.h"

@interface MNavigationController ()

@end

@implementation MNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"]   forBarMetrics:UIBarMetricsDefault];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        
    }
}
-(void)popself

{
    [self popViewControllerAnimated:NO];
    
}

-(UIBarButtonItem*) createBackButton

{
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]
            
            initWithCustomView:backbtn];
    
}
@end
