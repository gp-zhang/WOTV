//
//  LiveViewController.m
//  WOTV
//
//  Created by Gf_zgp on 14-6-14.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView *mLiveTable;
@end

@implementation LiveViewController
@synthesize mLiveTable=_mLiveTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    if (self.mLiveTable == nil) {
        self.mLiveTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _mLiveTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _mLiveTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mLiveTable.dataSource = self;
        _mLiveTable.delegate = self;
    }
    [self.view addSubview:_mLiveTable];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _mLiveTable) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mLiveTable) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mLiveTable) {
        NSString *Identifier = @"mLiveTable";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AllCustomCell" owner:self options:0] objectAtIndex:0];
        }
        return cell;
    }
    return nil;
}

#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

@end
