THEOS_DEVICE_IP = localhost -o StrictHostKeyChecking=no
THEOS_DEVICE_PORT = 2222

INSTALL_TARGET_PROCESSES = lockdownd

ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
TARGET = iphone:clang:latest:15.0
else
TARGET = iphone:clang:latest:9.0
endif

ARCHS = arm64 arm64e
DEBUG = 0


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = XcodeRootDebug

XcodeRootDebug_FILES = Tweak.x
XcodeRootDebug_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = XcodeRootDebugPrefs

XcodeRootDebugPrefs_FILES = XRDRootListController.m
XcodeRootDebugPrefs_FRAMEWORKS = UIKit
XcodeRootDebugPrefs_PRIVATE_FRAMEWORKS = Preferences
XcodeRootDebugPrefs_INSTALL_PATH = /Library/PreferenceBundles
XcodeRootDebugPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk