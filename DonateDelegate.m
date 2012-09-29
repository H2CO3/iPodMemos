//
// DonateDelegate.m
// iPodMemos
//
// Created by Árpád Goretity, 2011.
// All rights reserved
//

#import "DonateDelegate.h"

static id _shared = nil;

@implementation DonateDelegate

// class methods

+ (id)sharedInstance
{
	if (_shared == nil) {
		_shared = [[self alloc] init];
	}
	return _shared;
}

// self

- (id)init
{
	if ((self = [super init])) {
		donateURL = [[NSURL alloc] initWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ASTPZY69JGEGW"];
	}
	return self;
}

- (void)showAlertIfNeeded
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IPMDonateShown20"])
		return;

	UIAlertView *av = [[UIAlertView alloc] init];
	av.delegate = self;
	av.title = @"Please donate";
	av.message = @"Lots of work went into the development of iPod memos and its auxiliary softwares. If you enjoy using this tweak, please donate to me to support development (and be awesome)!";
	[av addButtonWithTitle:@"Donate"];
	[av addButtonWithTitle:@"Later"];
	[av show];
	[av release];
}

// super

- (void)dealloc
{
	[donateURL release];
	[super dealloc];
}

// UIAlertViewDelegate

- (void)alertView:(UIAlertView *)av didDismissWithButtonIndex:(int)index
{
	if (index == 0) {
		// Donate
		[[UIApplication sharedApplication] openURL:donateURL];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IPMDonateShown20"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

@end
