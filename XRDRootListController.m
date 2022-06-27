#import <Foundation/Foundation.h>
#import "XRDRootListController.h"
#include <notify.h>

@implementation XRDRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)saveSetting {
    notify_post("com.byteage.xcoderootdebug/preferences.changed");
}
@end
