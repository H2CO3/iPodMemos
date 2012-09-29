//
// DonateDelegate.h
// iPodMemos
//
// Created by Árpád Goretity, 2011.
// All rights reserved
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DonateDelegate: NSObject <UIAlertViewDelegate> {
	NSURL *donateURL;
}

+ (id)sharedInstance;
- (void)showAlertIfNeeded;

@end
