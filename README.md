# NSAlert+Popover

This category adds methods to open the alert within a NSPopover below any kind of NSView. The alerts do not run as modal windows, that is, your app continues execution while the alert's result will be processed in a execution block.

![NSAlert+Popover Preview](https://s3.amazonaws.com/cocoacontrols_production/uploads/control_image/image/715/original.jpg "NSAlert shown within a NSPopover using the NSAlert+Popover category")

## Usage

Create a NSAlert and call ```runAsPopoverForView:withCompletionBlock:;```:

	NSAlert *alert = [NSAlert alertWithMessageText:@"Do you really want to delete this item?"
										 defaultButton:@"Delete"
									   alternateButton:@"Learn more"
										   otherButton:@"Cancel"
							 informativeTextWithFormat:@"Deleting this item will erase all associated data in the database. Click learn more if you need additional information."];
						 
	[alert runAsPopoverForView:self.showNextDateButton withCompletionBlock:^(NSInteger *result) {
		// handle result
	}];

## Requirements

NSPopovers require at least OS X 10.7 (OS X Lion).
This category has been built for and tested **with ARC enabled** only!
 
## Contact

* Raffael Hannemann
* [@raffael_me](http://www.twitter.com/raffael_me/)
* http://www.raffael.me/

## License

Copyright (c) 2013 Raffael Hannemann
Under BSD License.

## Want more?

Follow [@raffael_me](http://www.twitter.com/raffael_me/) for similar releases.