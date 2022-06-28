# XcodeRootDebug

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

# ScreenShots

![](ScreenShots/20220627_235849.png)
![](ScreenShots/20220628_000606_898.png)

# XcodeRootDebug

允许`xcode`使用`root`权限启动自定义的`debugserver`调试iOS应用。

目前只在以下越狱设备上进行了测试：

* iPhone 6s 14.2
* iPhone 7 13.6.1
* iPhone 11 Pro 14.2

理论上支持iOS10以上设备，包括A12。

Cydia 源：https://repo.byteage.com

# 背景

通常情况下，我们使用`xcode`进行真机调试时有如下限制:

1. 只能以`mobile`权限启动调试器
2. 启动的调试器只能是`/Developer/usr/bin/debugserver`

基于上面的限制，产生了以下问题：

1. 无法调试系统进程，如：`Cydia`、`Safiri`
2. 无法调试`AppStore`下载的应用，应用需要砸壳后重签名

要解决上面的问题，需要使用具有高权限的`debugserver`，具体的配置过程，可以参考文章 [iOS12 下配置debugserver + lldb调试环境的小技巧和问题处理](https://iosre.com/t/ios12-debugserver-lldb/14429)。

要解决上面的限制，就需要安装本插件。

安装本插件以后，将允许开发者使用`xcode`以`root`权限启动自定义的`debugserver`进行调试。

你可以在设置中对插件进行设置。

# 截图
![](ScreenShots/20220627_235849.png)
![](ScreenShots/20220628_000606_898.png)
