// Copyright (c) 2016 rickytan <ricky.tan.xin@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

#import "UIViewController+RTRootNavigationController.h"


@interface RTContainerController : UIViewController
@property (nonatomic, readonly, strong) __kindof UIViewController *contentViewController;
@end


/**
 *  This Controller will forward all @a Navigation actions to its containing navigation controller, i.e. @b RTRootNavigationController.
 *  If you are using UITabBarController in your project, it's recommand to wrap it in @b RTRootNavigationController as follows:
 *  @code
tabController.viewControllers = @[[[RTContainerNavigationController alloc] initWithRootViewController:vc1],
                                  [[RTContainerNavigationController alloc] initWithRootViewController:vc2],
                                  [[RTContainerNavigationController alloc] initWithRootViewController:vc3],
                                  [[RTContainerNavigationController alloc] initWithRootViewController:vc4]];
self.window.rootViewController = [[RTRootNavigationController alloc] initWithRootViewController:tabController];
 *  @endcode
 */
@interface RTContainerNavigationController : UINavigationController
@end




IB_DESIGNABLE
@interface RTRootNavigationController : UINavigationController

/*!
 *  @brief use system original back bar item or custom back bar item returned by
 *  @code
- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action
 *  @endcode default is NO
 *  @warning Set this to YES will @b increase memory usage!
 */
@property (nonatomic, assign) IBInspectable BOOL useSystemBackBarButtonItem;

@property (nonatomic, assign) IBInspectable BOOL transferNavigationBarAttributes;   // Weather each individual navigation bar uses the visual style of root navigation bar. Default is YES

/*!
 *  @brief use this property instead of @b visibleViewController to get the current visiable content view controller
 */
@property (nonatomic, readonly, strong) UIViewController *rt_visibleViewController;

/*!
 *  @brief use this property instead of @b topViewController to get the content view controller on the stack top
 */
@property (nonatomic, readonly, strong) UIViewController *rt_topViewController;

/*!
 *  @brief use this property to get all the content view controllers;
 */
@property (nonatomic, readonly, strong) NSArray <__kindof UIViewController *> *rt_viewControllers;

/*!
 *  @brief Remove a content view controller from the stack
 *
 *  @param controller the content view controller
 */
- (void)removeViewController:(UIViewController *)controller NS_REQUIRES_SUPER;
- (void)removeViewController:(UIViewController *)controller animated:(BOOL)flag NS_REQUIRES_SUPER;

/*!
 *  @brief Push a view controller and do sth. when animation is done
 *
 *  @param viewController new view controller
 *  @param animated       use animation or not
 *  @param block          animation complete callback block
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                  complete:(void(^)(BOOL finished))block;

/*!
 *  @brief Pop to a specific view controller with a complete handler
 *
 *  @param viewController The view controller to pop  to
 *  @param animated       use animation or not
 *  @param block          complete handler
 *
 *  @return A array of UIViewControllers(content controller) poped from the stack
 */
- (NSArray <__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                      animated:(BOOL)animated
                                                      complete:(void(^)(BOOL finished))block;

/*!
 *  @brief Pop to root view controller with a complete handler
 *
 *  @param animated use animation or not
 *  @param block    complete handler
 *
 *  @return A array of UIViewControllers(content controller) poped from the stack
 */
- (NSArray <__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
                                                                  complete:(void(^)(BOOL finished))block;
@end
