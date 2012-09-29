//
// TagViewController.m
// iPodMemos
//
// Created by Árpád Goretity, 2011.
// All rights reserved
//

#import <stdlib.h>
#import <stdio.h>
#import "TagViewController.h"

#define CELL_ID @"IPMMetaCell"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@implementation TagViewController

// the designated initializer
- (id)initWithPath:(NSString *)path title:(NSString *)aTitle
{
	if ((self = [super init]) == nil) {
		return nil;
	}

	self.navigationItem.title = @"Attributes";
	self.tableView.allowsSelection = NO;
	title = [aTitle copy];
	file = [path copy];

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];

	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target: self action: @selector(close)];
	self.navigationItem.leftBarButtonItem = closeButton;
	[closeButton release];

	labels = [[NSArray alloc] initWithObjects:@"Title", @"Artist", @"Genre", @"Year", nil];
	textFields = [[NSMutableArray alloc] init];
	int i;
	for (i = 0; i < [labels count]; i++) {
		UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH / 2, 30)];
		tf.delegate = self;
		tf.text = @"";
		[textFields addObject:tf];
		[tf release];
	}

	return self;
}

// super
- (void)dealloc
{
	[labels release];
	[textFields release];
	[super dealloc];
}

// UITableViewDelegate
- (int)tableView:(UITableView *)tv numberOfRowsInSection:(int)section
{
	return [textFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
			reuseIdentifier:CELL_ID]
		autorelease];
	}
	cell.textLabel.text = [labels objectAtIndex:ip.row];
	cell.accessoryView = [textFields objectAtIndex:ip.row];
	return cell;
}

// UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

// self
- (void)presentFromViewController:(UIViewController *)vctrl
{
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:self];
	[vctrl presentModalViewController:navCtrl animated:YES];
	[navCtrl release];
}

- (void)done
{
	// Add track
	NSMutableDictionary *meta = [NSMutableDictionary dictionary];
	NSArray *keys = [NSArray arrayWithObjects:
		kIPIKeyTitle,
		kIPIKeyArtist,
		kIPIKeyGenre,
		kIPIKeyYear,
		nil
	];

	int i;
	for (i = 0; i < [keys count]; i++) {
		[meta setObject:[[textFields objectAtIndex:i] text] forKey:[keys objectAtIndex:i]];
	}
	[meta setObject:@"iPod Memos" forKey:kIPIKeyAlbum];

	NSString *tmp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"iPodMemos.m4a"];
	symlink([file UTF8String], [tmp UTF8String]);

	[[IPIPodImporter sharedInstance] importFileAtPath:tmp withMetadata:meta];
	[[[[UIAlertView alloc]
		initWithTitle:@"Voice memo added"
		message:@"This voice memo has been added to your iPod library successfully."
		delegate:nil
		cancelButtonTitle:@"Dismiss"
		otherButtonTitles:nil
	] autorelease] show];
	[self close];
}

- (void)close
{
	[self dismissModalViewControllerAnimated:YES];
}

@end

