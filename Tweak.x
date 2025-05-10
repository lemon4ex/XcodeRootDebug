#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>
#include <unistd.h>
#include <substrate.h>
#import <rootless.h>

extern char **environ;

#define LOG(fmt, ...) NSLog(@"[XcodeRootDebug] " fmt "\n", ##__VA_ARGS__)

static NSString * nsDomainString = @"com.byteage.xcoderootdebug";
static NSString * nsNotificationString = @"com.byteage.xcoderootdebug/preferences.changed";
static BOOL enabled;
static NSString *debugserverPath;
static BOOL isRootUser;

static void reloadSettings() {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.byteage.xcoderootdebug.plist"];
	NSNumber * enabledValue = (NSNumber *)[settings objectForKey:@"enabled"];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;
	debugserverPath = [settings objectForKey:@"debugserverPath"];
	if(!debugserverPath.length) {
		debugserverPath = ROOT_PATH_NS(@"/usr/bin/debugserver");
	}
	NSNumber * isRootUserValue = (NSNumber *)[settings objectForKey:@"isRootUser"];
	isRootUser = (isRootUserValue)? [isRootUserValue boolValue] : YES;
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	// kill self
	exit(0);
}

// If the compiler understands __arm64e__, assume it's paired with an SDK that has
// ptrauth.h. Otherwise, it'll probably error if we try to include it so don't.
#if __arm64e__
#include <ptrauth.h>
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

// Given a pointer to instructions, sign it so you can call it like a normal fptr.
static void *make_sym_callable(void *ptr) {
#if __arm64e__
    ptr = ptrauth_sign_unauthenticated(ptrauth_strip(ptr, ptrauth_key_function_pointer), ptrauth_key_function_pointer, 0);
#endif
    return ptr;
}

// Given a function pointer, strip the PAC so you can read the instructions.
static void *make_sym_readable(void *ptr) {
#if __arm64e__
    ptr = ptrauth_strip(ptr, ptrauth_key_function_pointer);
#endif
    return ptr;
}

#pragma clang diagnostic pop

typedef CFTypeRef AuthorizationRef;

bool (*original_SMJobSubmit)(CFStringRef domain, CFDictionaryRef job, AuthorizationRef auth, CFErrorRef _Nullable *error);

static NSString *systemDebugserverPath;

bool hooked_SMJobSubmit(CFStringRef domain, CFDictionaryRef job, AuthorizationRef auth, CFErrorRef _Nullable *error) {
	LOG(@"Enter hooked_SMJobSubmit %@", job);
	NSMutableDictionary *newJobInfo = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)job];
	NSMutableArray *programArgs = [newJobInfo[@"ProgramArguments"] mutableCopy];
	NSString *program = programArgs[0];
	if (enabled) {
		if([program isEqualToString:@"/Developer/usr/bin/debugserver"] || [program isEqualToString:@"/usr/libexec/debugserver"]) {
			LOG("Found launch %@", program);
			systemDebugserverPath = [program copy];
			if(debugserverPath.length > 0 && access(debugserverPath.UTF8String, F_OK) == 0){
				LOG("Change to launch %@", debugserverPath);
				programArgs[0] = debugserverPath;
				newJobInfo[@"ProgramArguments"] = programArgs;
			} else {
				LOG("Debug Server does not exist at %@", debugserverPath);
			}
			if(isRootUser) {
				LOG("Change to launch with root");
				newJobInfo[@"UserName"] = @"root";
			} else {
				newJobInfo[@"UserName"] = @"mobile";
			}
			LOG(@"Now SMJobSubmit %@", newJobInfo);
		} else if([program isEqualToString:debugserverPath]) {
			LOG("Found launch %@",debugserverPath);
			if(isRootUser) {
				LOG("Change to launch with root");
				newJobInfo[@"UserName"] = @"root";
			} else {
				newJobInfo[@"UserName"] = @"mobile";
			}
			LOG(@"Now SMJobSubmit %@", newJobInfo);
		}
	} else {
		if([program isEqualToString:debugserverPath]) {
			LOG("Found launch %@", debugserverPath);
			LOG("Restore launch system debugserver at %@ with mobile", systemDebugserverPath);
			programArgs[0] = systemDebugserverPath;
			newJobInfo[@"ProgramArguments"] = programArgs;
			newJobInfo[@"UserName"] = @"mobile";
			LOG(@"Now SMJobSubmit %@", newJobInfo);
		}
	}
	LOG(@"New SMJobSubmit %@", newJobInfo);
	return original_SMJobSubmit(domain, (__bridge CFDictionaryRef)newJobInfo, auth, error);
}

%ctor {
  LOG(@"loaded in %s (%d)", getprogname(), getpid());
  reloadSettings();

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

  MSImageRef image = MSGetImageByName("/System/Library/PrivateFrameworks/ServiceManagement.framework/ServiceManagement");
  if (!image) {
    LOG("ServiceManagement framework not found, it is impossible");
    return;
  }
  MSHookFunction(
    MSFindSymbol(image, "_SMJobSubmit"),
    (void *)hooked_SMJobSubmit,
    (void **)&original_SMJobSubmit
  );
}
