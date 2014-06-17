//
//  AvplayerPlaybackViewController.h
//  AirPlay
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
@class AvPlayerPlaybackView;
@interface AvplayerPlaybackViewController : CommonViewController<AVAudioPlayerDelegate>
{
@private
	 AvPlayerPlaybackView* mPlaybackView;
	 UISlider* mScrubber;
     UIToolbar *mToolbar;
     UIBarButtonItem *mPlayButton;
     UIBarButtonItem *mStopButton;
    
	float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;
    CGRect DefaultBounds;
	NSURL* mURL;
    BOOL canbePlay;
	AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
}
@property (nonatomic, strong) NSURL* URL;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (strong) AVPlayerItem* mPlayerItem;
@property (nonatomic, strong)  AvPlayerPlaybackView *mPlaybackView;
@property (nonatomic,strong) UIScrollView *BackgroundScrollView;
@property (nonatomic, strong)  UIToolbar *mToolbar;
@property (nonatomic, strong)  UIActivityIndicatorView *mActivity;
@property (nonatomic, strong)  UIBarButtonItem *mPlayButton;
@property (nonatomic, strong)  UIBarButtonItem *mStopButton;
@property (nonatomic, strong)  UIBarButtonItem *mInfoButton;
@property (nonatomic, assign)  CGRect DefaultBounds;
@property (nonatomic, strong)  UISlider* mScrubber;

- (void)play:(id)sender;
- (void)pause:(id)sender;
- (void)showMetadata:(id)sender;

@end
