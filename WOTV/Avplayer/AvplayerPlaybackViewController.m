//
//  AvplayerPlaybackViewController.m
//  AirPlay
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AvplayerPlaybackViewController.h"
#import "AvPlayerPlaybackView.h"
#import "AVPlayerMetadataViewController.h"
#import <MediaPlayer/MPVolumeView.h>
#import <AVFoundation/AVFoundation.h>

/* Asset keys */
NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";

/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";


@interface AvplayerPlaybackViewController ()

- (void)play:(id)sender;
- (void)pause:(id)sender;
- (void)showMetadata:(id)sender;
- (void)initScrubberTimer;
- (void)showPlayButton;
- (void)showStopButton;
- (void)syncScrubber;
- (IBAction)beginScrubbing:(id)sender;
- (IBAction)scrub:(id)sender;
- (IBAction)endScrubbing:(id)sender;
- (BOOL)isScrubbing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)init;
- (void)dealloc;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)viewDidLoad;
- (void)viewWillDisappear:(BOOL)animated;
- (void)handleSwipe:(UISwipeGestureRecognizer*)gestureRecognizer;
- (void)syncPlayPauseButtons;
- (void)setURL:(NSURL*)URL;
- (NSURL*)URL;

@end

@interface AvplayerPlaybackViewController (Player)
- (void)removePlayerTimeObserver;
- (CMTime)playerItemDuration;
- (BOOL)isPlaying;
- (void)playerItemDidReachEnd:(NSNotification *)notification ;
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

@implementation AvplayerPlaybackViewController
@synthesize mPlayer, mPlayerItem, mPlaybackView, mToolbar, mPlayButton, mStopButton, mScrubber,DefaultBounds,mInfoButton,BackgroundScrollView,mActivity;

#pragma mark Asset URL

- (void)setURL:(NSURL*)URL
{
	if (mURL != URL)
	{
		mURL = URL;
		
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset keys "tracks", "playable".
         */
        
        NSLog(@"%@",URL);
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mURL options:nil];
        
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
        
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
         }];
	}
}

- (NSURL*)URL
{
	return mURL;
}

#pragma mark -
#pragma mark Movie controller methods

#pragma mark
#pragma mark Button Action Methods

- (void)play:(id)sender
{
	/* If we are at the end of the movie, we must seek to the beginning first
     before starting playback. */
	if (YES == seekToZeroBeforePlay)
	{
		seekToZeroBeforePlay = NO;
		[self.mPlayer seekToTime:kCMTimeZero];
	}
//    [SVProgressHUD show];

	[self.mPlayer play];
	
    [self showStopButton];
}

- (void)pause:(id)sender
{
	[self.mPlayer pause];
    
    [self showPlayButton];
}

/* Display AVMetadataCommonKeyTitle and AVMetadataCommonKeyCopyrights metadata. */
- (void)showMetadata:(id)sender
{
	AVPlayerMetadataViewController* metadataViewController = [[AVPlayerMetadataViewController alloc] init];
    
	[metadataViewController setMetadata:[[[self.mPlayer currentItem] asset] commonMetadata]];
	
	[self presentViewController:metadataViewController animated:YES completion:NULL];
}

#pragma mark -
#pragma mark Play, Stop buttons

/* Show the stop button in the movie player controller. */
-(void)showStopButton
{
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.mToolbar items]];
    if (self.mStopButton){
        [toolbarItems replaceObjectAtIndex:0 withObject:self.mStopButton];
    }
    self.mToolbar.items = toolbarItems;
}

/* Show the play button in the movie player controller. */
-(void)showPlayButton
{
    if (self.mPlayButton){
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.mToolbar items]];
        [toolbarItems replaceObjectAtIndex:0 withObject:self.mPlayButton];
        self.mToolbar.items = toolbarItems;
    }
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
	if ([self isPlaying])
	{
        [mActivity stopAnimating];
        [self showStopButton];
	}
	else
	{
        [self showPlayButton];
	}
}

-(void)enablePlayerButtons
{
    self.mPlayButton.enabled = YES;
    self.mStopButton.enabled = YES;
}

-(void)disablePlayerButtons
{
    self.mPlayButton.enabled = NO;
    self.mStopButton.enabled = NO;
}

#pragma mark -
#pragma mark Movie scrubber control

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer
{
	double interval = .1f;
	
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		return;
	}
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
		interval = 0.5f * duration / width;
	}
    
	/* Update the scrubber during normal playback. */
    __block AvplayerPlaybackViewController *playbackVC = self;
	mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL /* If you pass NULL, the main queue is used. */
                                                          usingBlock:^(CMTime time)
                     {
                         [playbackVC syncScrubber];
                     }] ;
    
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		mScrubber.minimumValue = 0.0;
		return;
	}
    
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		float minValue = [self.mScrubber minimumValue];
		float maxValue = [self.mScrubber maximumValue];
		double time = CMTimeGetSeconds([self.mPlayer currentTime]);
		
		[self.mScrubber setValue:(maxValue - minValue) * time / duration + minValue];
	}
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (IBAction)beginScrubbing:(id)sender
{
	mRestoreAfterScrubbingRate = [self.mPlayer rate];
	[self.mPlayer setRate:0.f];
	
	/* Remove previous timer. */
	[self removePlayerTimeObserver];
}

/* Set the player current time to match the scrubber position. */
- (IBAction)scrub:(id)sender
{
	if ([sender isKindOfClass:[UISlider class]])
	{
		UISlider* slider = sender;
		
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration)) {
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
			float minValue = [slider minimumValue];
			float maxValue = [slider maximumValue];
			float value = [slider value];
			
			double time = duration * (value - minValue) / (maxValue - minValue);
			
			[self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
		}
	}
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (IBAction)endScrubbing:(id)sender
{
	if (!mTimeObserver)
	{
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration))
		{
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
			CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
			double tolerance = 0.5f * duration / width;
            __block AvplayerPlaybackViewController *playbackVC = self;

			mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
                             ^(CMTime time)
                             {
                                 [playbackVC syncScrubber];
                             }] ;
		}
	}
    
	if (mRestoreAfterScrubbingRate)
	{
		[self.mPlayer setRate:mRestoreAfterScrubbingRate];
		mRestoreAfterScrubbingRate = 0.f;
	}
}

- (BOOL)isScrubbing
{
	return mRestoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    self.mScrubber.enabled = YES;
}

-(void)disableScrubber
{
    self.mScrubber.enabled = NO;
}


#pragma mark
#pragma mark View Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		[self setPlayer:nil];
        
        //		[self setWantsFullScreenLayout:YES];
	}
	
	return self;
}

- (id)init
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [self initWithNibName:@"AvplayerPlaybackViewController" bundle:nil];
	}
    else
    {
        return [self initWithNibName:@"AvplayerPlaybackViewController" bundle:nil];
	}
}

- (void)viewDidUnload
{
    [self.mPlaybackView.player pause];
    [self.mPlayer pause];
    self.mPlaybackView.player = nil;
    self.mPlaybackView = nil;
	
    self.mToolbar = nil;
    self.mPlayButton = nil;
    self.mStopButton = nil;
    self.mScrubber = nil;
    mTimeObserver= nil;
    mURL = nil;

    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    if (self.mPlayer) {
        [self.mPlayer pause];
    }
	[self setPlayer:nil];
    if (self.BackgroundScrollView == nil) {
        self.BackgroundScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    }

    BackgroundScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.BackgroundScrollView];
	UIView* view  = BackgroundScrollView;
    
    self.mPlaybackView=[[AvPlayerPlaybackView alloc]initWithFrame:view.frame];
    self.mPlaybackView.autoresizesSubviews=YES;
    /*    UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
     UIViewAutoresizingFlexibleWidth        = 1 << 1,
     UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
     UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
     UIViewAutoresizingFlexibleHeight       = 1 << 4,
     UIViewAutoresizingFlexibleBottomMargin = 1 << 5*/
    self.mPlaybackView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [view addSubview:mPlaybackView];
    
    self.mToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, view.frame.size.height-44, 320, 44)];
    self.mToolbar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    self.mToolbar.autoresizesSubviews=YES;
    self.mToolbar.barStyle=UIBarStyleBlackTranslucent;
    self.mScrubber=[[UISlider alloc]initWithFrame:CGRectMake(0, 0, 200, 23)];
    self.mScrubber.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    self.mActivity = [[UIActivityIndicatorView alloc]init];
    mActivity.center = self.view.center;
    mActivity.bounds = CGRectMake(0, 0, 60, 60);
    mActivity.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [mActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [mActivity setHidesWhenStopped:YES];
    [mPlaybackView addSubview:mActivity];
    [mPlaybackView addSubview:self.mToolbar];
    [self.mScrubber addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [self.mScrubber addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchCancel];
    [self.mScrubber addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventTouchDragInside];
    [self.mScrubber addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
    [self.mScrubber addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
    [self.mScrubber addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
    
    self.mPlayButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
    self.mStopButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause:)];
    //
//	UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//	[swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//	[view addGestureRecognizer:swipeUpRecognizer];
    //
    //
    //	UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    //	[swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    //	[view addGestureRecognizer:swipeDownRecognizer];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired=2;
    self.mPlaybackView.userInteractionEnabled=YES;
    [self.mPlaybackView addGestureRecognizer:tapGesture];
    
    //    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:volumeView];
    //    [self.view addSubview:volumeView];
    //    [self.mScrubber sizeToFit];
    
    UIBarButtonItem *scrubberItem = [[UIBarButtonItem alloc] initWithCustomView:self.mScrubber];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setImage:[UIImage imageNamed:@"movieFullscreen.png"] forState:UIControlStateNormal];
    [infoButton setImage:[UIImage imageNamed:@"movieEndFullscreen.png"] forState:UIControlStateSelected];
    infoButton.bounds=CGRectMake(0, 0, 25, 25);
    [infoButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [infoButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [infoButton sizeToFit];
    [infoButton addTarget:self action:@selector(showMetadata:) forControlEvents:UIControlEventTouchUpInside];
    self.mInfoButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;
    volumeView.frame=CGRectMake(0,0,20 ,20);
    [volumeView setShowsVolumeSlider:NO];
    [volumeView setShowsRouteButton:YES];
    [volumeView sizeToFit];
    UIBarButtonItem *AirplayBtn=[[UIBarButtonItem alloc]initWithCustomView:volumeView];
    
    self.mToolbar.items = [NSArray arrayWithObjects:self.mPlayButton,scrubberItem, AirplayBtn, self.mInfoButton, nil];
    //    self.mToolbar.tintColor=[UIColor blackColor];
    
	[self initScrubberTimer];
	
	[self syncPlayPauseButtons];
	[self syncScrubber];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    canbePlay = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.mPlayer pause];
    canbePlay = NO;
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.mPlayer pause];
    canbePlay = NO;
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)setViewDisplayName
{
    /* Set the view title to the last component of the asset URL. */
    self.title = [mURL lastPathComponent];
    
    /* Or if the item has a AVMetadataCommonKeyTitle metadata, use that instead. */
	for (AVMetadataItem* item in ([[[self.mPlayer currentItem] asset] commonMetadata]))
	{
		NSString* commonKey = [item commonKey];
		
		if ([commonKey isEqualToString:AVMetadataCommonKeyTitle])
		{
			self.title = [item stringValue];
		}
	}
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
	UISwipeGestureRecognizerDirection direction = [gestureRecognizer direction];
	
    
    if (direction == UISwipeGestureRecognizerDirectionUp)
    {
        [UIView animateWithDuration:0.2f animations:
         ^{
             [[self navigationController] setNavigationBarHidden:YES animated:YES];
         } completion:
         ^(BOOL finished)
         {
             [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
         }];
    }
    if (direction == UISwipeGestureRecognizerDirectionDown)
    {
        [UIView animateWithDuration:0.2f animations:
         ^{
             [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
         } completion:
         ^(BOOL finished)
         {
             [[self navigationController] setNavigationBarHidden:NO animated:YES];
         }];
    }
    
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    
    if (![self.mToolbar isHidden])
    {
        self.mToolbar.alpha=1;
        [UIView animateWithDuration:0.2f animations:
         ^{
             self.mToolbar.alpha=0;
         } completion:
         ^(BOOL finished)
         {
             [self.mToolbar setHidden:YES];
         }];
    }
    else
    {
        [self.mToolbar setHidden:NO];
        self.mToolbar.alpha=0;
        [UIView animateWithDuration:0.2f animations:
         ^{
             self.mToolbar.alpha=1;
         } completion:^(BOOL finished){}];
    }
    
}

- (void)dealloc
{
	[self removePlayerTimeObserver];
	
	[self.mPlayer removeObserver:self forKeyPath:@"rate"];
	[mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
	
	[self.mPlayer pause];
	self.mPlayer = nil;
	
    mURL = nil;
}


@end

@implementation AvplayerPlaybackViewController (Player)

#pragma mark Player Item



- (BOOL)isPlaying
{
	return mRestoreAfterScrubbingRate != 0.f || [self.mPlayer rate] != 0.f;
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
	/* After the movie has played to its end time, seek back to time zero
     to play it again. */
	seekToZeroBeforePlay = YES;
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
	AVPlayerItem *playerItem = [self.mPlayer currentItem];
	if (playerItem.status == AVPlayerItemStatusReadyToPlay)
	{
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
		return([playerItem duration]);
	}
	
	return(kCMTimeInvalid);
}


/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (mTimeObserver)
	{
		[self.mPlayer removeTimeObserver:mTimeObserver];
		mTimeObserver = nil;
	}
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    [self syncScrubber];
    [self disableScrubber];
    [self disablePlayerButtons];
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}


#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
		/* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
	}
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
        
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
	/* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.mPlayerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.mPlayerItem removeObserver:self forKeyPath:kStatusKey context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.mPlayerItem];
    }
    
    
//    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
//    NSMutableArray *allAudioParams = [NSMutableArray array];
//    for (AVAssetTrack *track in audioTracks) {
//        AVMutableAudioMixInputParameters *audioInputParams =
//        [AVMutableAudioMixInputParameters audioMixInputParameters];
//        [audioInputParams setVolume:0.0 atTime:kCMTimeZero];
//        [audioInputParams setTrackID:[track trackID]];
//        [allAudioParams addObject:audioInputParams];
//    }
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    [audioMix setInputParameters:allAudioParams];

    
//    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
//    
//
//    
//    
//    
//    AVURLAsset* videoAsset = asset;
//    
//    AVMutableComposition* mixComposition = [AVMutableComposition composition];
//    
//    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
//    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
//                                        ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
//                                         atTime:kCMTimeZero error:nil];
//    
//    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
//                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
//    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
//                                   ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
//                                    atTime:kCMTimeZero error:nil];
    
//    AVMutableVideoComposition *videoCom = [AVMutableVideoComposition videoComposition];
//
//    
//    AVMutableCompositionTrack *compositionCommentaryTrack = [videoCom addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    
//    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
//                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
//                                         atTime:kCMTimeZero error:nil];
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    
    
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
//    self.mPlayerItem = [[AVPlayerItem alloc] init];
//    [self.mPlayerItem setAudioMix:audioMix];
//    [self.mPlayerItem setVideoComposition:videoCom];
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self
                       forKeyPath:kStatusKey
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
	
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
	
    seekToZeroBeforePlay = NO;
	
    /* Create new player, if we don't already have one. */
    if (!self.mPlayer)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];
		
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.mPlayer addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.mPlayer addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.mPlayer.currentItem != self.mPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        
        [self syncPlayPauseButtons];
    }
	
    [self.mScrubber setValue:0.0];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
	if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
	{
		[self syncPlayPauseButtons];
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
//                [SVProgressHUD show];
                NSLog(@"statusUnkonwn");
                [mActivity startAnimating];
                [self removePlayerTimeObserver];
                [self syncScrubber];
                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"statusReadyToPlay");
//                [SVProgressHUD dismiss];
                [mActivity stopAnimating];

                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                if (canbePlay) {
                    [self.mPlayer play];
                }
                [self initScrubberTimer];
                
                [self enableScrubber];
                [self enablePlayerButtons];
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"statusFailed");
                [mActivity stopAnimating];
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
	}
	/* AVPlayer "rate" property value observer. */
	else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
	{
        [self syncPlayPauseButtons];
	}
	/* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
	else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            NSLog(@"NULL");
            [self disablePlayerButtons];
            [self disableScrubber];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [self.mPlaybackView setPlayer:mPlayer];
            
            [self setViewDisplayName];
            
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            [self syncPlayPauseButtons];
        }
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}


@end


