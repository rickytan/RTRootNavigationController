@import XCTest;
@import UIKit;

#import <RTRootNavigationController/RTRootNavigationController.h>

@interface RTRootNavigationController (BackItemTests)
- (void)_installsLeftBarButtonItemIfNeededForViewController:(UIViewController *)viewController;
@end

@interface RTCustomBackTestController : UIViewController
@property (nonatomic, assign) BOOL horizontalOnly;
@property (nonatomic, assign) NSUInteger creationCount;
@property (nonatomic, strong) UIBarButtonItem *createdItem;
@end

@implementation RTCustomBackTestController

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    self.creationCount++;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage systemImageNamed:@"chevron.backward"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.createdItem = [[UIBarButtonItem alloc] initWithCustomView:button];
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        if (self.horizontalOnly) {
            self.createdItem.axisBehavior = UIBarButtonItemAxisBehaviorHorizontalOnly;
        }
    }
#endif
    return self.createdItem;
}

@end

@interface RTTextBackTestController : UIViewController
@property (nonatomic, assign) BOOL horizontalOnly;
@property (nonatomic, strong) UIBarButtonItem *createdItem;
@end

@implementation RTTextBackTestController

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    self.createdItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                       style:UIBarButtonItemStylePlain
                                                      target:target
                                                      action:action];
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        if (self.horizontalOnly) {
            self.createdItem.axisBehavior = UIBarButtonItemAxisBehaviorHorizontalOnly;
        }
    }
#endif
    return self.createdItem;
}

@end

@interface RTLegacyBackTestController : UIViewController
@property (nonatomic, strong) UIBarButtonItem *createdItem;
@end

@implementation RTLegacyBackTestController

- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action
{
    self.createdItem = [[UIBarButtonItem alloc] initWithTitle:@"Legacy"
                                                       style:UIBarButtonItemStylePlain
                                                      target:target
                                                      action:action];
    return self.createdItem;
}

@end

@interface Tests : XCTestCase
@end

@implementation Tests

- (RTRootNavigationController *)navigationControllerWithDetail:(UIViewController *)detail
{
    UIViewController *root = [[UIViewController alloc] init];
    RTRootNavigationController *navigationController =
        [[RTRootNavigationController alloc] initWithRootViewController:root];
    [navigationController loadViewIfNeeded];
    [navigationController pushViewController:detail animated:NO];
    [navigationController _installsLeftBarButtonItemIfNeededForViewController:detail];
    return navigationController;
}

- (void)assertVerticalRepresentationForTextItem:(UIBarButtonItem *)item
                                 viewController:(UIViewController *)viewController
{
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        XCTAssertEqual(item.axisBehavior, UIBarButtonItemAxisBehaviorVerticalPreferred);
        if (viewController.traitCollection.verticalBarEdge == UIVerticalBarEdgeUnspecified) {
            XCTAssertNil(item.image);
        } else {
            XCTAssertNotNil(item.image);
        }
    } else {
        XCTAssertNil(item.image);
    }
#else
    XCTAssertNil(item.image);
#endif
}

- (void)testDefaultBackItemPopsTheOuterStack
{
    UIViewController *detail = [[UIViewController alloc] init];
    RTRootNavigationController *navigationController = [self navigationControllerWithDetail:detail];
    UIBarButtonItem *item = detail.navigationItem.leftBarButtonItem;

    XCTAssertNotNil(item);
    XCTAssertEqualObjects(item.title, NSLocalizedString(@"Back", nil));
    XCTAssertEqual(item.target, navigationController);
    [self assertVerticalRepresentationForTextItem:item viewController:detail];
    XCTAssertTrue([UIApplication.sharedApplication sendAction:item.action to:item.target from:item forEvent:nil]);
    XCTAssertEqual(navigationController.rt_viewControllers.count, 1u);
}

- (void)testCustomViewBackItemPopsTheOuterStack
{
    RTCustomBackTestController *detail = [[RTCustomBackTestController alloc] init];
    RTRootNavigationController *navigationController = [self navigationControllerWithDetail:detail];
    UIBarButtonItem *item = detail.navigationItem.leftBarButtonItem;

    XCTAssertEqual(item, detail.createdItem);
    XCTAssertEqual(detail.creationCount, 1u);
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        XCTAssertEqual(item.axisBehavior, UIBarButtonItemAxisBehaviorVerticalPreferred);
    }
#endif
    XCTAssertNil(item.image);
    [navigationController _installsLeftBarButtonItemIfNeededForViewController:detail];
    XCTAssertEqual(detail.creationCount, 1u);
    [(UIButton *)item.customView sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqual(navigationController.rt_viewControllers.count, 1u);
}

- (void)testDeprecatedCustomBackFactoryIsPreserved
{
    RTLegacyBackTestController *detail = [[RTLegacyBackTestController alloc] init];
    RTRootNavigationController *navigationController = [self navigationControllerWithDetail:detail];
    UIBarButtonItem *item = detail.navigationItem.leftBarButtonItem;

    XCTAssertEqual(item, detail.createdItem);
    XCTAssertEqualObjects(item.title, @"Legacy");
    [self assertVerticalRepresentationForTextItem:item viewController:detail];
    XCTAssertTrue([UIApplication.sharedApplication sendAction:item.action to:item.target from:item forEvent:nil]);
    XCTAssertEqual(navigationController.rt_viewControllers.count, 1u);
}

- (void)testTextOnlyCustomBackItemKeepsItsTitleAndAction
{
    RTTextBackTestController *detail = [[RTTextBackTestController alloc] init];
    RTRootNavigationController *navigationController = [self navigationControllerWithDetail:detail];
    UIBarButtonItem *item = detail.navigationItem.leftBarButtonItem;

    XCTAssertEqual(item, detail.createdItem);
    XCTAssertEqualObjects(item.title, @"Close");
    XCTAssertEqual(item.target, navigationController);
    [self assertVerticalRepresentationForTextItem:item viewController:detail];
    XCTAssertTrue([UIApplication.sharedApplication sendAction:item.action to:item.target from:item forEvent:nil]);
    XCTAssertEqual(navigationController.rt_viewControllers.count, 1u);
}

- (void)testExplicitHorizontalOnlyCustomItemIsRespected
{
    RTCustomBackTestController *detail = [[RTCustomBackTestController alloc] init];
    detail.horizontalOnly = YES;
    [self navigationControllerWithDetail:detail];
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        XCTAssertEqual(detail.createdItem.axisBehavior, UIBarButtonItemAxisBehaviorHorizontalOnly);
    }
#endif
}

- (void)testExplicitHorizontalOnlyTextItemIsRespected
{
    RTTextBackTestController *detail = [[RTTextBackTestController alloc] init];
    detail.horizontalOnly = YES;
    [self navigationControllerWithDetail:detail];

    XCTAssertNil(detail.createdItem.image);
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        XCTAssertEqual(detail.createdItem.axisBehavior, UIBarButtonItemAxisBehaviorHorizontalOnly);
    }
#endif
}

- (void)testExistingLeftItemAndRootAreNotChanged
{
    UIViewController *detail = [[UIViewController alloc] init];
    UIBarButtonItem *existing = [[UIBarButtonItem alloc] initWithTitle:@"Existing"
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:nil];
    detail.navigationItem.leftBarButtonItem = existing;
    RTRootNavigationController *navigationController = [self navigationControllerWithDetail:detail];
    UIViewController *root = navigationController.rt_viewControllers.firstObject;
    [navigationController _installsLeftBarButtonItemIfNeededForViewController:root];

    XCTAssertEqual(detail.navigationItem.leftBarButtonItem, existing);
    XCTAssertNil(root.navigationItem.leftBarButtonItem);
#if defined(__IPHONE_27_1) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_27_1
    if (@available(iOS 27.1, *)) {
        XCTAssertEqual(existing.axisBehavior, UIBarButtonItemAxisBehaviorAutomatic);
    }
#endif
}

- (void)testSystemBackModeDoesNotInstallCustomItem
{
    UIViewController *root = [[UIViewController alloc] init];
    RTCustomBackTestController *detail = [[RTCustomBackTestController alloc] init];
    RTRootNavigationController *navigationController =
        [[RTRootNavigationController alloc] initWithRootViewController:root];
    navigationController.useSystemBackBarButtonItem = YES;
    [navigationController loadViewIfNeeded];
    [navigationController pushViewController:detail animated:NO];
    [navigationController _installsLeftBarButtonItemIfNeededForViewController:detail];

    XCTAssertNil(detail.navigationItem.leftBarButtonItem);
    XCTAssertEqual(detail.creationCount, 0u);
    XCTAssertEqual(detail.navigationController.viewControllers.count, 2u);
}

@end
