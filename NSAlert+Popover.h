//
//  NSAlert+Popover.h
//
//  Created by Raffael Hannemann on 30.04.13.
//  Copyright (c) 2013 Raffael Hannemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^NSAlertCompletionBlock)(NSInteger result);

/** This category adds methods to run an NSAlert within a NSPopover below any kind of NSView.
 */
@interface NSAlert (Popover)

/** This block will be executed with the index of the button, the user has clicked, as the parameter.
 */
@property (copy) NSAlertCompletionBlock completionBlock;

/** The reference to the parent Popover, that contains this alert, is required to close the Popover from within the button click handling.
 */
@property (retain) NSPopover *parentPopover;

/** The target view below which this alert will be popped over. The reference is required for enqueuing mumtuple Popover alerts.
 */
@property (retain) NSView *targetView;

/** The main method of this category to open an NSAlert within a NSPopover below any kind of NSView.
 */
- (void) runAsPopoverForView:(NSView *)aView preferredEdge:(NSRectEdge)preferredEdge withCompletionBlock:(NSAlertCompletionBlock)aBlock;

/** Convenient method that uses NSYMaxEdge as preferred edge.
 */
- (void) runAsPopoverForView:(NSView *)aView withCompletionBlock:(NSAlertCompletionBlock)aBlock;

@end