//
//  LiveViewController.m
//  WOTV
//
//  Created by Gf_zgp on 14-6-14.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "LiveViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "AppDelegate.h"
#import "UPnPManager.h"
#import "UPnPDB.h"
#import "mURLConnection.h"
#import "GDataXMLNode.h"
#import "IptvChannelMode.h"
#import "LiveDetailViewController.h"
@interface LiveViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderViewForLive;
    BOOL _reloadingForLive;
    int pageForLive;
}
@property (strong,nonatomic)UITableView *mLiveTable;
@property (strong,nonatomic)NSMutableArray *mLiveArray;
@end

@implementation LiveViewController
@synthesize mLiveArray=_mLiveArray;
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
        
        
        _refreshHeaderViewForLive= [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,  - self.view.bounds.size.height, 320, self.view.bounds.size.height)];
        _refreshHeaderViewForLive.delegate = self;
        [_mLiveTable addSubview:_refreshHeaderViewForLive];
        [_refreshHeaderViewForLive refreshLastUpdatedDate];
        _reloadingForLive=NO;
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

        return _mLiveArray.count;
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
        
        IptvChannelMode *im= [_mLiveArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = im.ChannelName;
        return cell;
    }
    return nil;
}

#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _mLiveTable)
    {
        IptvChannelMode *im= [_mLiveArray objectAtIndex:indexPath.row];
        LiveDetailViewController *detail = [[LiveDetailViewController alloc]init];
        detail.mChannel = im;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mLiveTable)
    {
        [_refreshHeaderViewForLive egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     if (scrollView == _mLiveTable)
    {
        [_refreshHeaderViewForLive egoRefreshScrollViewDidEndDragging:scrollView];
    }
}



#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
   
    if (view == _refreshHeaderViewForLive)
    {
        _reloadingForLive = YES;
        [self reloadTableViewDataSourceForLive];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    if (view == _refreshHeaderViewForLive) {
        return   _reloadingForLive;
        
    }
    
	return NO; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



#pragma mark LoadLiveTableView Data

- (void)reloadTableViewDataSourceForLive
{
 
    AppDelegate *appdelegate = [AppDelegate share];
    if (appdelegate.mDevice) {
        
        BasicUPnPService *service = [appdelegate.mDevice getServiceForType:@"urn:schemas-upnp-org:service:ContentDirectory:1"];
        
        if(service)
        {
        NSURL *url = service.baseURL;
        
        NSURL *actionURL = [NSURL URLWithString:service.controlURL relativeToURL:url];
        
        NSLog(@"%@",actionURL);
        NSDictionary *parameters = nil;
        NSString *soapAction = @"GetChannelList";
        NSString *upnpNameSpace = @"urn:schemas-upnp-org:service:ContentDirectory:1";
        NSString *responseGroupTag = [NSString stringWithFormat:@"u:%@Response", soapAction];
        
        mURLConnection *murl = [[mURLConnection alloc]init];
        [murl SoapActionWithUrl:actionURL HttpMethod:@"POST" Action:soapAction Parameters:parameters NameSpace:upnpNameSpace Complete:^(id responseData) {
            NSLog(@"%@",responseData);
            NSError *error = nil;
            GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithXMLString:responseData options:0 error:&error] ;
            if (error) {
                NSLog(@"error--> %@",error);
            }
            NSArray *array = [doc nodesForXPath:[NSString stringWithFormat:@"//ChannelSynopsisInfo"] namespaces:[NSDictionary dictionaryWithObjectsAndKeys:responseGroupTag,@"u", nil] error:nil];
            
            if (self.mLiveArray == nil) {
                self.mLiveArray = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [_mLiveArray removeAllObjects];
            for (GDataXMLElement *key in array) {
                IptvChannelMode *im = [[IptvChannelMode alloc] initIptvChannelModel:key.XMLString];
                
                if (im != nil) {
                    [_mLiveArray addObject:im];
                }
            }
            
            [self doneLoadingTableViewDataForLive];
            
            
        } onError:^(id responseCode, id error) {
            DLog(@"%@",murl.HttpRequest.URL);
            
            [self doneLoadingTableViewDataForLive];

        }];
        
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请检查所选设备是否正确!" duration:1];
            [self performSelector:@selector(doneLoadingTableViewDataForLive) withObject:nil afterDelay:0.3];

        }
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"GBOX未连接"];
        [self performSelector:@selector(doneLoadingTableViewDataForLive) withObject:nil afterDelay:0.3];
    }
}

- (void)doneLoadingTableViewDataForLive{
    
    _reloadingForLive = NO;

    [_refreshHeaderViewForLive egoRefreshScrollViewDataSourceDidFinishedLoading:self.mLiveTable];
    
    if ([_mLiveArray count] > 0) {
        [_mLiveTable reloadData];
    }

}

@end
