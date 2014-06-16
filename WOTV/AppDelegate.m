//
//  AppDelegate.m
//  WOTV
//
//  Created by Gf_zgp on 14-6-13.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "AppDelegate.h"

#import "GHMenuViewController.h"
#import "GHRevealViewController.h"
#import "CommonViewController.h"
#import "GHMenuCell.h"
#import "LiveViewController.h"
#import "MNavigationController.h"
#import "DeviceListViewController.h"
#import "ControllViewController.h"
@interface AppDelegate ()
@property (nonatomic, strong) GHRevealViewController *revealController;
@property (nonatomic, strong) GHMenuViewController *menuController;
@property (nonatomic, strong) UIView *headView;
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
	self.revealController.view.backgroundColor = bgColor;
    RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kGHRevealSidebarDefaultAnimationDuration];
	};
    
    NSArray *headers = @[
                         [NSNull null],
                         @" 影视",
                         @" 私有云",
                         @" 智能家具",
                         @" 更多"
                         ];
	NSArray *controllers = @[
                             @[
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"未登录" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[DeviceListViewController alloc] initWithTitle:@"GBOX连接" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[ControllViewController alloc] initWithTitle:@"GBOX遥控器" withRevealBlock:revealBlock]]
                                 ],
                             
                             @[
                                 [[MNavigationController alloc] initWithRootViewController:[[LiveViewController alloc] initWithTitle:@"直播" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"在线影视" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"影视搜索" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"我的影视" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"本机资源" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"文件管理" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"智能下载" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"通讯录" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"Booadlink设备" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"遥控面板" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"定时任务" withRevealBlock:revealBlock]],
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"一键执行" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[MNavigationController alloc] initWithRootViewController:[[CommonViewController alloc] initWithTitle:@"设置" withRevealBlock:revealBlock]]
                                 ]
                             ];
	NSArray *cellInfos = @[
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 未登录", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" GBOX连接", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" GBOX遥控器", @"")}
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 直播", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 在线影视", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 影视搜索", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 我的影视", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 本机资源", @"")}
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 文件管理", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 智能下载", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 通讯录", @"")}
                               
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" Broadlink设备", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 遥控面板", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 定时任务", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 一键执行", @"")}
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@" 设置", @"")}
                               
                               ]
                           ];
	
	// Add drag feature to each root navigation controller
	[controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
																						 action:@selector(dragContentView:)];
			panGesture.cancelsTouchesInView = YES;
			[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
		}];
	}];
    
    
    self.menuController = [[GHMenuViewController alloc] initWithSidebarViewController:self.revealController
																		withHeadView:self.headView
																		  withHeaders:headers
																	  withControllers:controllers
																		withCellInfos:cellInfos];
    self.window.rootViewController = self.revealController;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
