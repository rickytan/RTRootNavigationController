//
//  RTViewControllerAnimatedTransitioning.h
//  RTRootNavigationController
//
//  Created by chenguixin on 2020/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RTViewControllerAnimatedTransitioning <UIViewControllerAnimatedTransitioning>

- (id<UIViewControllerInteractiveTransitioning>)rt_interactiveTransitioning;

@end

NS_ASSUME_NONNULL_END
