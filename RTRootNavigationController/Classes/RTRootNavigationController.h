//
//  RTRootNavigationController.h
//  Pods
//
//  Created by ricky on 16/6/8.
//
//

#import <UIKit/UIKit.h>

@interface RTRootNavigationController : UINavigationController
@property (nonatomic, readonly, strong) UIViewController *rt_visibleViewController;
@property (nonatomic, readonly, strong) UIViewController *rt_topViewController;

- (void)removeViewController:(UIViewController *)controller;
@end
