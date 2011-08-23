//
// TagViewController.m
// iPodMemos
//
// Created by Árpád Goretity, 2011.
// All rights reserved
//

#import "TagViewController.h"

#define CELL_ID @"IPMMetaCell"

@implementation TagViewController

// the designated initializer
- (id) initWithPath: (NSString *) path title: (NSString *) aTitle {
	self = [super init];
	self.navigationItem.title = @"Attributes";
	self.tableView.allowsSelection = NO;
	title = [aTitle copy];
	file = [path copy];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(close)];
	self.navigationItem.leftBarButtonItem = closeButton;
	[closeButton release];
	labels = [[NSArray alloc] initWithObjects: @"Title", @"Album", @"Artist", @"Genre", @"Year", @"Composer", @"Comment", @"Rating", @"Category", nil];
	textFields = [[NSMutableArray alloc] init];
	for (int i = 0; i < 9; i++) {
		UITextField *tf = [[UITextField alloc] initWithFrame: CGRectMake (0, 9, 160, 30)];
		tf.delegate = self;
		[textFields addObject: tf];
		[tf release];
	}
	[[textFields objectAtIndex: 0] setText: title];
	[[textFields objectAtIndex: 1] setText: @"Voice Memos"];
	[[textFields objectAtIndex: 2] setText: [[UIDevice currentDevice] name]];
	[[textFields objectAtIndex: 3] setText: @"Recording"];
	[[textFields objectAtIndex: 6] setText: @"Added using iPod Memos by H2CO3"];
	return self;
}

// super
- (void) dealloc {
	[labels release];
	[textFields release];
	[super dealloc];
}

// UITableViewDelegate
- (int) tableView: (UITableView *) tv numberOfRowsInSection: (int) section {
	return 9;
}

- (UITableViewCell *) tableView: (UITableView *) tv cellForRowAtIndexPath: (NSIndexPath *) ip {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier: CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CELL_ID] autorelease];
	}
	cell.textLabel.text = [labels objectAtIndex: ip.row];
	cell.accessoryView = [textFields objectAtIndex: ip.row];
	return cell;
}

// UITextFieldDelegate
- (BOOL) textFieldShouldReturn: (UITextField *) textField {
	[textField resignFirstResponder];
	return YES;
}

// self
- (void) presentFromViewController: (UIViewController *) vctrl {
	parent = [vctrl retain];
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController: self];
	[parent presentModalViewController: navCtrl animated: YES];
	[navCtrl release];
}

- (void) done {
	MFMusicTrack *track = [[MFMusicTrack alloc] init];
	track.title = [[textFields objectAtIndex: 0] text];
	track.album = [[textFields objectAtIndex: 1] text];
	track.artist = [[textFields objectAtIndex: 2] text];
	track.genre = [[textFields objectAtIndex: 3] text];
	track.year = [[textFields objectAtIndex: 4] text];
	track.composer = [[textFields objectAtIndex: 5] text];
	track.comment = [[textFields objectAtIndex: 6] text];
	track.rating = [[[textFields objectAtIndex: 7] text] intValue];
	track.category = [[textFields objectAtIndex: 8] text];
	track.mediatype = ITDB_MEDIATYPE_AUDIO;
	[[MFMusicLibrary sharedLibrary] addFile: file asTrack: track];
	BOOL success = [[MFMusicLibrary sharedLibrary] write];
	if (success) {
		[[[[UIAlertView alloc] initWithTitle: @"Memo added" message: [NSString stringWithFormat: @"The recording '%@' was added to the iPod.", track.title] delegate: nil cancelButtonTitle: @"Dismiss" otherButtonTitles: nil] autorelease] show];
	} else {
		[[[[UIAlertView alloc] initWithTitle: @"Error" message: [NSString stringWithFormat: @"The recording '%@' could not be added to the iPod.", track.title] delegate: nil cancelButtonTitle: @"Dismiss" otherButtonTitles: nil] autorelease] show];
	}
	[track release];
	[self close];
	
}

- (void) close {
	[parent dismissModalViewControllerAnimated: YES];
	[parent release];
}

@end

