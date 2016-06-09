//
//  UIViewController+RTRootNavigationController.h
//  Pods
//
//  Created by ricky on 16/6/9.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIViewController (RTRootNavigationController)

@property (nonatomic, assign) IBInspectable BOOL rt_disableInteractivePop;

- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action;

@end
