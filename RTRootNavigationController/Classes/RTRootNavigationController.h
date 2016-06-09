//
//  RTRootNavigationController.h
//  Pods
//
//  Created by ricky on 16/6/8.
//
//

#import <UIKit/UIKit.h>

/*!
 *  @brief DO NOT change the RTRootNavigationController.delegate directly, instead use rt_delegate
 */
@interface RTRootNavigationController : UINavigationController

@property (nonatomic, weak) id<UINavigationControllerDelegate> rt_delegate;

/*!
 *  @brief use this property instead of `visibleViewController` to get the current visiable content view controller
 */
@property (nonatomic, readonly, strong) UIViewController *rt_visibleViewController;

/*!
 *  @brief use this property instead of `topViewController` to get the content view controller on the stack top
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
- (void)removeViewController:(UIViewController *)controller;

@end
