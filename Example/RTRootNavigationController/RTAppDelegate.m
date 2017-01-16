//
//  RTAppDelegate.m
//  RTRootNavigationController
//
//  Created by rickytan on 06/08/2016.
//  Copyright (c) 2016 rickytan. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

#import "RTAppDelegate.h"


@implementation RTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /*
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main"
                                                    bundle:nil];
    UITabBarController *tabController = [[UITabBarController alloc] init];
//    tabController.tabBar.translucent = NO;
    if (YES) {
        tabController.viewControllers = @[[[RTContainerNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Root"]],
                                          [[RTContainerNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Remove"]],
                                          [[RTContainerNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Scroll"]],
                                          [[RTContainerNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Table"]]];
        self.window.rootViewController = [[RTRootNavigationController alloc] initWithRootViewControllerNoWrapping:tabController];
    }
    else {
        tabController.viewControllers = @[[[RTRootNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Root"]],
                                          [[RTRootNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Remove"]],
                                          [[RTRootNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Scroll"]],
                                          [[RTRootNavigationController alloc] initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"Table"]]];
        self.window.rootViewController = tabController;
    }
    */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
