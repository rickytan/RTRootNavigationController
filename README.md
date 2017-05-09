# RTRootNavigationController

[![CI Status](http://img.shields.io/travis/rickytan/RTRootNavigationController.svg?style=flat)](https://travis-ci.org/rickytan/RTRootNavigationController)
[![Version](https://img.shields.io/cocoapods/v/RTRootNavigationController.svg?style=flat)](http://cocoapods.org/pods/RTRootNavigationController)
[![License](https://img.shields.io/cocoapods/l/RTRootNavigationController.svg?style=flat)](http://cocoapods.org/pods/RTRootNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/RTRootNavigationController.svg?style=flat)](http://cocoapods.org/pods/RTRootNavigationController)

## Introduction
More and more apps use custom navigation bar for each different view controller, instead of one common, global navigation bar.

This project just help develops to solve this problem in a tricky way, develops use this navigation controller in a farmilar way just like you used to be, and you can have each view controller a individual navigation bar.

越来越多的应用为每一个 **VC** 设置单独的导航条，而不是之前那样使用一个全局统一的导航条，因为不同的 **VC** 有不同的视觉样式，前一个是蓝色的，后一个也许要做成红色、透明，或者干脆没有导航条。

虽然开发者可以在每个 **VC** 的 `- (void)viewWillAppear` （想想为什么不是 `- (void)viewDidLoad`） 方法中设置自己所需的样式，但是在同一个导航条上来回修改，稍不注意就会导致样式混乱。另一种实现方式，是隐藏全局那个导航条，每个 **VC** 自己通过 `addSubview:(UIView *)view` 的方式自己设置导航条。这种实现是可行的，但是使用不方便了，如：
- 无法使用 `self.navigationItem.rightBarButtonItem` 等来设置导航按钮，而必须自己手动往 `navigationBar` 上加；
- 无法使用 `self.title` 来修改导航标题，而必须自己添加监听；
- 无法方便地设置 `navigationBarHidden`；
- 无法方便地自动调整 `contentInsets`。

等等。

本项目提供一种透明的方式，让开发者像以前一样使用导航器，同时，每个 `push` 进来的 **VC** 有自己独立的导航条。

## Features

* Custom navigation bar class support
* Unwind support
* Rotation support
* Interactive pop enable and disable support
* `Interface Builder` support

* 每个 **VC** 支持自定义的 `navigationBarClass`
* 支持 `unwind`（不知道什么是 `unwind`？请参考：[这里](https://developer.apple.com/library/ios/technotes/tn2298/_index.html)）
* 支持转屏
* 支持禁用交互式返回
* 支持 `Interface Builder`

![screenshot](./ScreenShot/1.png)

![scrreecap](./ScreenShot/2.gif)

## Usage

As an advise, please set `RTRootNavigationController` as your rootViewController:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    UIViewController *yourController = ...;
    self.window.rootViewController = [[RTRootNavigationController alloc] initWithRootViewController:yourController];
    return YES;
}
```

you can implement following method to customize back bar button item (**Recommended**):

```objective-c
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target
                                          action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
}
```

or just set `useSystemBackBarButtonItem` to **YES** and use the default one.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## __Notice__

Your **ViewController** hierarchy will change to:
```
RTRootNavigationController
    `- RTContainerViewController
    |       `- RTContainerNavigationController
    |               `- YourViewController1
    `- RTContainerViewController
            `- RTContainerNavigationController
                    `- YourViewController2
```
So, if you access `self.navigationController` it returns a container navigation controller, and its `viewControllers` will always be **1**, i.e. `self`. Instead, your have to use `self.rt_navigationController.rt_viewController` to get all siblings, as metioned **[Here](https://github.com/rickytan/RTRootNavigationController/blob/master/RTRootNavigationController/Classes/UIViewController%2BRTRootNavigationController.h#L36)** and **[Here](https://github.com/rickytan/RTRootNavigationController/blob/master/RTRootNavigationController/Classes/RTRootNavigationController.h#L81)**.

## Requirements

* **iOS 7** and up
* **Xcode 7** and up

## Installation

RTRootNavigationController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RTRootNavigationController"
```

## Author

rickytan, ricky.tan.xin@gmail.com

## Alternatives

- [**JTNavigationController**](https://github.com/JNTian/JTNavigationController)
  - 支持全屏返回
- [**FDFullscreenPopGesture**](https://github.com/forkingdog/FDFullscreenPopGesture)
  - 使用原生的 *UINavigationController*，在 `- (void)viewWillAppear` 中做处理
  - 支持全屏返回
  
## Apps Integrated

* [网易美学](https://itunes.apple.com/cn/app/%E7%BD%91%E6%98%93%E7%BE%8E%E5%AD%A6-%E9%A2%9C%E5%80%BC%E6%9C%80%E9%AB%98%E7%9A%84%E7%BE%8E%E5%A6%86%E7%A4%BE%E5%8C%BA/id1147533466?mt=8)

## License

RTRootNavigationController is available under the MIT license. See the LICENSE file for more info.
