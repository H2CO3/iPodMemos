//
// TagViewController.h
// iPodMemos
//
// Created by Árpád Goretity, 2011.
// All rights reserved
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MFMusicLibrary/MFMusicLibrary.h>

@interface TagViewController: UITableViewController <UITextFieldDelegate> {
	NSMutableArray *textFields;
	NSArray *labels;
	NSString *title;
	NSString *file;
	UIViewController *parent;
}

- (id) initWithPath: (NSString *) path title: (NSString *) aTitle;
- (void) presentFromViewController: (UIViewController *) vc;
- (void) close;

@end
