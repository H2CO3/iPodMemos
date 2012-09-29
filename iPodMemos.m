//
// iPodMemos.m
// iPodMemos
//
// Created by Árpád Goretity, 2011.
// All rights reserved
//

#import <objc/runtime.h>
#import <stdio.h>
#import <unistd.h>
#import <substrate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DonateDelegate.h"
#import "TagViewController.h"

static IMP _original_numsecs;
static IMP _original_cell;
static IMP _original_select;
static IMP _original_launch;
static int num_sections;

int _modified_numsecs(id _self, SEL _cmd, UITableView *tv)
{
	num_sections = (int)_original_numsecs(_self, _cmd, tv);
	return num_sections + 1;
}

UITableViewCell *_modified_cell(id _self, SEL _cmd, UITableView *tv, NSIndexPath *ip)
{
	if (ip.section < num_sections) {
		return _original_cell(_self, _cmd, tv, ip);
	} else {
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
		cell.textLabel.text = @"Add to iPod";
		cell.detailTextLabel.text = @"Make sure to specify metadata";
		return cell;
	}
}

void _modified_select(id _self, SEL _cmd, UITableView *tv, NSIndexPath *ip)
{
	if (ip.section < num_sections) {
		_original_select(_self, _cmd, tv, ip);
	} else {
		// show tags editing view controller
		TagViewController *tvc = [[TagViewController alloc] initWithPath:[[_self recording] path] title:[[_self recording] label]];
		[tvc presentFromViewController:_self];
		[tvc release];
	}
}

void _modified_launch(id _self, SEL _cmd, id app)
{
	_original_launch (_self, _cmd, app);
	[[DonateDelegate sharedInstance] showAlertIfNeeded];
}

__attribute__((constructor))
extern void init()
{
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	MSHookMessageEx(objc_getClass("RCRecordingDetailViewController"), @selector(numberOfSectionsInTableView:), (IMP)_modified_numsecs, &_original_numsecs);
	MSHookMessageEx(objc_getClass("RCRecordingDetailViewController"), @selector(tableView:cellForRowAtIndexPath:), (IMP)_modified_cell, &_original_cell);
	MSHookMessageEx(objc_getClass("RCRecordingDetailViewController"), @selector(tableView:willSelectRowAtIndexPath:), (IMP)_modified_select, &_original_select);
	MSHookMessageEx(objc_getClass("RecorderAppDelegate"), @selector(applicationDidFinishLaunching:),(IMP)_modified_launch, &_original_launch);
}

