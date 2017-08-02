//
//  RTWebViewController.h
//  RTRootNavigationController
//
//  Created by ricky on 16/6/10.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface RTWebViewController : UIViewController
@property (nonatomic, readonly, strong) WKWebView *webView;
@end
