#import "ObjectiveCConsumer.h"
@import RTRootNavigationController;

BOOL ObjectiveCConsumerSmokeTest(void)
{
    UIViewController *root = [[UIViewController alloc] init];
    RTRootNavigationController *navigation =
        [[RTRootNavigationController alloc] initWithRootViewController:root];
    UIViewController *detail = [[UIViewController alloc] init];
    [navigation pushViewController:detail animated:NO];
    detail.rt_disableInteractivePop = YES;

    return root.rt_navigationController == navigation
        && detail.rt_navigationController == navigation
        && navigation.rt_viewControllers.count == 2
        && detail.rt_disableInteractivePop;
}
