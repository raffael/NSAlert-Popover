//
//  NSAlert+MenuItemPopUp.m
//  Glow Foundation
//
//  Created by Raffael Hannemann on 30.04.13.
//  Copyright (c) 2013 Raffael Hannemann. All rights reserved.
//

#import "NSAlert+Popover.h"
#import <objc/runtime.h>

@implementation NSAlert (Popover)

static char COMPLETIONBLOCK_KEY;
static char PARENTPOPOVER_KEY;
static char TARGETVIEW_KEY;
static NSMutableArray *previouslyOpenedAlerts;
static NSPopover *currentlyOpenedPopover;
static NSAlert *currentlyOpenedAlert;

- (void) runAsPopoverForView:(NSView *) aView withCompletionBlock:(NSAlertCompletionBlock) aBlock {
	[self runAsPopoverForView:aView prefferedEdge:NSMaxYEdge withCompletionBlock:aBlock];
}

- (void) runAsPopoverForView:(NSView *) view prefferedEdge:(NSRectEdge)prefferedEdge withCompletionBlock:(NSAlertCompletionBlock)block {
	
	// Set this alert as the target of all its buttons
	for (NSButton *button in [self buttons]) {
		[button setTarget:self];
		[button setAction:@selector(stopSynchronousPopoverAlert:)];
	}
	
	// Store block and target view references for later usage
	self.completionBlock = block;
	self.targetView = view;
	
	// Force a layout update, which hides unused buttons
	[self layout];
	
	if (!previouslyOpenedAlerts) {
		previouslyOpenedAlerts = [NSMutableArray array];
	}

	// Instantiate a new NSPopover with a view controller that manages this alert's view
	NSViewController *controller = [[NSViewController alloc] init];
	NSPopover *popover = [[NSPopover alloc] init];
	[controller setView:[self.window contentView]];
	[popover setContentViewController:controller];
	
	// Store the reference to this alert's parent popover
	[self setParentPopover:popover];
	
	// Enqueue the potentially currently opened alert 
	if (currentlyOpenedPopover) {
		[previouslyOpenedAlerts addObject:currentlyOpenedAlert];
		[currentlyOpenedPopover close];
	}
	
	// Open the alert within the popover and mark it as the currently shown one.
	[popover showRelativeToRect:view.bounds ofView:view preferredEdge:NSMaxYEdge];
	currentlyOpenedPopover = popover;
	currentlyOpenedAlert = self;
}

- (void) stopSynchronousPopoverAlert: (NSButton *) clickedButton {
	
	// Determine clicked button index
	NSUInteger clickedIx = [[self buttons] indexOfObject:clickedButton];

	// And determine the return code of this button
	NSInteger returnCode = 0;	
	switch (clickedIx) {
		case NSAlertFirstButtonReturn:
		case NSAlertSecondButtonReturn:
		case NSAlertThirdButtonReturn:
			returnCode = clickedIx;
			break;
		default:
			returnCode = NSAlertThirdButtonReturn +clickedIx -2;
			break;
	}
	
	// Execute the calback with the return code
	if (self.completionBlock) self.completionBlock(returnCode);
	
	// Close the popover and remove if from the queue
	NSPopover *parent = self.parentPopover;
	if (parent) [parent close];
	currentlyOpenedAlert = nil;
	currentlyOpenedPopover = nil;
	
	// Check for previously shown Popover Alerts
	[self checkForPreviouslyShownAlerts];
}

- (void) checkForPreviouslyShownAlerts {
	// If previously opened alerts are referenced, open the last one.
	if (previouslyOpenedAlerts.count>0) {
		NSAlert *alert = [previouslyOpenedAlerts lastObject];
		[previouslyOpenedAlerts removeObject:alert];
		[alert runAsPopoverForView:alert.targetView withCompletionBlock:alert.completionBlock];
	}
}

/**
 * The following methods are required to add properties to the category.
 */

// Property Completion Block
- (void) setCompletionBlock: (NSAlertCompletionBlock) block{
	objc_setAssociatedObject(self, &COMPLETIONBLOCK_KEY, block, OBJC_ASSOCIATION_COPY);
}
- (NSAlertCompletionBlock) completionBlock {
	return objc_getAssociatedObject(self, &COMPLETIONBLOCK_KEY);
}

// Property Parent Popover
- (void) setParentPopover:(NSPopover *)parentPopover {
	objc_setAssociatedObject(self, &PARENTPOPOVER_KEY, parentPopover, OBJC_ASSOCIATION_RETAIN);
}
- (NSPopover *) parentPopover {
	return objc_getAssociatedObject(self, &PARENTPOPOVER_KEY);
}

// Property Target View
- (void) setTargetView:(NSPopover *)targetView {
	objc_setAssociatedObject(self, &TARGETVIEW_KEY, targetView, OBJC_ASSOCIATION_RETAIN);
}
- (NSView *) targetView {
	return objc_getAssociatedObject(self, &TARGETVIEW_KEY);
}

@end
