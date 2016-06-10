# RTRootNavigationController

[![CI Status](http://img.shields.io/travis/rickytan/RTRootNavigationController.svg?style=flat)](https://travis-ci.org/rickytan/RTRootNavigationController)
[![Version](https://img.shields.io/cocoapods/v/RTRootNavigationController.svg?style=flat)](http://cocoapods.org/pods/RTRootNavigationController)
[![License](https://img.shields.io/cocoapods/l/RTRootNavigationController.svg?style=flat)](http://cocoapods.org/pods/RTRootNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/RTRootNavigationController.svg?style=flat)](http://cocoapods.org/pods/RTRootNavigationController)

## Introduction
More and more apps use custom navigation bar for each different view controller, instead of one common, gloabal navigation bar.

This project just help develops to solve this problem in a tricky way, develops use this navigation controller in a farmilar way just like you used to be, and
you can have each view controller a individual navigation bar.

## Feature

* Custom navigation bar class support
* Unwind support
* Rotation support
* Interactive pop enable and disable support
* `Interface Builde` support

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

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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

## License

RTRootNavigationController is available under the MIT license. See the LICENSE file for more info.
