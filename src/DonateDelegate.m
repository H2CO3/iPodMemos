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

+ (id) sharedInstance {
	if (_shared == nil) {
		_shared = [[self alloc] init];
	}
	return _shared;
}

// self

- (id) init {
	self = [super init];
	donateURL = [[NSURL alloc] initWithString: @"http://h2co3.zxq.net/"];
	return self;
}

// super

- (void) dealloc {
	[donateURL release];
	[super dealloc];
}

// UIAlertViewDelegate

- (void) alertView: (UIAlertView *) av didDismissWithButtonIndex: (int) index {
	if (index == 0) {
		// Donate
		[[UIApplication sharedApplication] openURL: donateURL];
	}
}

@end
