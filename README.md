# XcodeRootDebug

[中文](https://github.com/lemon4ex/XcodeRootDebug/blob/main/README_CN.md)

Allow `xcode` to start a custom `debugserver` with `root` privileges to debug iOS apps.

Currently only tested on the following jailbroken devices:

* iPhone 6s 14.2
* iPhone 7 13.6.1
* iPhone 11 Pro 14.2

Theoretically supports iOS10 and above devices, including A12.

Repo：https://repo.byteage.com

# Background

Usually, when we use `xcode` for real machine debugging, there are the following limitations:

1. The debugger can only be started with `mobile` permissions
2. The debugger that can be started can only be `/Developer/usr/bin/debugserver`

Based on the above limitations, the following problems arise:

1. Unable to debug system processes, such as: `Cydia`、`Safiri`
2. Unable to debug the app downloaded from `AppStore`, the app needs to be re-signed after smashing the shell

To solve the above problems, you need to use `debugserver` with high permissions. For the specific configuration process, you can refer to the article [Tips and Problem Handling for Configuring DebugServer + lldb Debugging Environment under iOS12](https://iosre.com/t/ios12-debugserver-lldb/14429).

To solve the above limitations, you need to install this tweak.

After installing this tweak, it will allow developers to use `xcode` to start a custom `debugserver` with `root` privileges for debugging.

You can set the tweak in settings。

# Article

You can read [this post](https://byteage.com/154.html?from=github) to get some information.

# ScreenShots

![](ScreenShots/20220627_235849.png)
![](ScreenShots/20220628_000606_898.png)
