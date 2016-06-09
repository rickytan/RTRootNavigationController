//
//  UIViewController+RTRootNavigationController.m
//  Pods
//
//  Created by ricky on 16/6/9.
//
//

#import <objc/runtime.h>

#import "UIViewController+RTRootNavigationController.h"

@implementation UIViewController (RTRootNavigationController)
@dynamic rt_disableInteractivePop;

- (void)setRt_disableInteractivePop:(BOOL)rt_disableInteractivePop
{
    objc_setAssociatedObject(self, @selector(rt_disableInteractivePop), @(rt_disableInteractivePop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_disableInteractivePop
{
    return [objc_getAssociatedObject(self, @selector(rt_disableInteractivePop)) boolValue];
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
}

@end
