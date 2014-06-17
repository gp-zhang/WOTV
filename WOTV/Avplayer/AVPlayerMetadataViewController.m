//
//  AVPlayerMetadataViewController.m
//  AirPlay
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AVPlayerMetadataViewController.h"
#import "AvPlayerPlaybackView.h"

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerMetadataViewController ()
- (void)setMetadata:(NSArray*)metadata;
- (IBAction)goAway:(id)sender;
@end

@implementation AVPlayerMetadataViewController

- (id)init
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [self initWithNibName:@"AVPlayerMetadataViewController" bundle:nil];
	}
    else
    {
        return [self initWithNibName:@"AVPlayerMetadataViewController" bundle:nil];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

/* Display the asset 'title' and 'copyright' metadata. */
- (void)syncLabels
{
	/* Assume no metadata was found. */
	[mTitleLabel setText:@"<Title metadata not found>"];
	[mCopyrightLabel setText:@"<Copyright metadata not found>"];
	
	for (AVMetadataItem* item in self->mMetadata)
	{
		NSString* commonKey = [item commonKey];
		
		if ([commonKey isEqualToString:AVMetadataCommonKeyTitle])
		{
			[mTitleLabel setText:[item stringValue]];
			[mTitleLabel setHidden:NO];
		}
		if ([commonKey isEqualToString:AVMetadataCommonKeyCopyrights])
		{
			[mCopyrightLabel setText:[item stringValue]];
			[mCopyrightLabel setHidden:NO];
		}
	}
}

- (NSArray*)metadata
{
	return self->mMetadata;
}

- (void)setMetadata:(NSArray*)metadata
{
	self->mMetadata = metadata;
	
	[self syncLabels];
}

- (IBAction)goAway:(id)sender
{
    if ([self respondsToSelector:@selector(presentingViewController)])
    {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [[self parentViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self syncLabels];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
