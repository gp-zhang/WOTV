//
//  OndemandViewController.m
//  WOTV
//
//  Created by Gf_zgp on 14-6-16.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "OndemandViewController.h"

@interface OndemandViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong,nonatomic)UICollectionView *mCollectionView;
@end

@implementation OndemandViewController
@synthesize mCollectionView=_mCollectionView;
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
    
    if (self.mCollectionView == nil) {
        UICollectionViewFlowLayout *grid = [[UICollectionViewFlowLayout alloc] init];
        grid.itemSize = CGSizeMake(75.0, 75.0);
        grid.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    
        self.mCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:grid];
        _mCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _mCollectionView.delegate = self;
        _mCollectionView.dataSource = self;
        [self.view addSubview:_mCollectionView];
        [_mCollectionView registerNib:[UINib nibWithNibName:@"OndemandCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ondemand"];

        [_mCollectionView reloadData];
    }
    
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


#pragma mark CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ondemand";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OndemandCollectionCell" owner:self options:0] objectAtIndex:1];
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    UICollectionViewTransitionLayout *myCustomTransitionLayout =
    [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return myCustomTransitionLayout;
}


@end
