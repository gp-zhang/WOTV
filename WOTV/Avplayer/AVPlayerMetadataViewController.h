//
//  AVPlayerMetadataViewController.h
//  AirPlay
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;
@interface AVPlayerMetadataViewController : UIViewController
{
@private
	IBOutlet UILabel* mTitleLabel;
	IBOutlet UILabel* mCopyrightLabel;
	
	NSArray* mMetadata;
}

@property (nonatomic, strong) NSArray* metadata;

- (void)setMetadata:(NSArray*)metadata;
- (IBAction)goAway:(id)sender;
@end
