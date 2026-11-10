#import "RTSceneDelegate.h"

#if DEBUG
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "RTViewController.h"
#endif

@implementation RTSceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }

    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];

#if DEBUG
    NSArray<NSString *> *arguments = NSProcessInfo.processInfo.arguments;
    NSUInteger index = [arguments indexOfObject:@"-RTBackScenario"];
    if (index != NSNotFound && index + 1 < arguments.count) {
        NSString *scenario = arguments[index + 1];
        RTRootNavigationController *navigationController = (RTRootNavigationController *)self.window.rootViewController;
        navigationController.useSystemBackBarButtonItem = [scenario isEqualToString:@"system"];
        UIViewController *detail = [scenario hasPrefix:@"custom"]
            ? [[RTViewController alloc] init] : [[UIViewController alloc] init];
        detail.title = @"Detail";
        detail.view.backgroundColor = UIColor.whiteColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 180, 400, 180)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = UIColor.blackColor;
        [detail.view addSubview:label];
        [navigationController pushViewController:detail animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIBarButtonItem *item = detail.navigationItem.leftBarButtonItem;
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
            if (@available(iOS 27.1, *)) {
                if ([scenario containsString:@"vertical"]) {
                    item.axisBehavior = UIBarButtonItemAxisBehaviorVerticalPreferred;
                }
                if ([scenario containsString:@"image"]) {
                    item.image = [UIImage systemImageNamed:@"chevron.backward"];
                }
                label.text = [NSString stringWithFormat:@"%@\nedge=%ld axis=%ld\nitem=%@\ncustom=%@",
                              scenario, (long)detail.traitCollection.verticalBarEdge, (long)item.axisBehavior,
                              item, item.customView];
            }
#endif
            NSLog(@"RTBackScenario %@ item=%@ custom=%@", scenario, item, item.customView);
        });
    }
#endif
}

@end
