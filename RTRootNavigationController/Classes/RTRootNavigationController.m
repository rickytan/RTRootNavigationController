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

#import "RTRootNavigationController.h"

#import "UIViewController+RTRootNavigationController.h"

@class RTContainerControllerInternal, RTContainerNavigationControllerInternal;


@interface NSArray (RTRootNavigationController)
- (NSArray *)rt_map:(id(^)(id obj))block;
- (BOOL)rt_some:(BOOL(^)(id obj))block;
@end

@implementation NSArray (RTRootNavigationController)

- (NSArray *)rt_map:(id (^)(id obj))block
{
    if (!block) {
        block = ^(id obj) {
            return obj;
        };
    }

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        [array addObject:block(obj)];
    }];
    return [NSArray arrayWithArray:array];
}

- (BOOL)rt_some:(BOOL (^)(id))block
{
    if (!block)
        return NO;

    __block BOOL result = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (block(obj)) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end


@interface RTContainerControllerInternal : UIViewController
@property (nonatomic, strong) __kindof UIViewController *contentViewController;
@property (nonatomic, strong) UINavigationController *containerNavigatioinController;

+ (instancetype)containerControllerWithController:(UIViewController *)controller;
- (instancetype)initWithController:(UIViewController *)controller;

@end

@interface RTContainerNavigationControllerInternal : UINavigationController
@end


static inline UIViewController *RTSafeUnwrapViewController(UIViewController *controller) {
    if ([controller isKindOfClass:[RTContainerControllerInternal class]]) {
        return ((RTContainerControllerInternal *)controller).contentViewController;
    }
    return controller;
}

static inline UIViewController *RTSafeWrapViewController(UIViewController *controller) {
    if (![controller isKindOfClass:[RTContainerControllerInternal class]]) {
        return [RTContainerControllerInternal containerControllerWithController:controller];
    }
    return controller;
}


@implementation RTContainerControllerInternal

+ (instancetype)containerControllerWithController:(UIViewController *)controller
{
    return [[self alloc] initWithController:controller];
}

- (instancetype)initWithController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.contentViewController = controller;
        self.containerNavigatioinController = [[RTContainerNavigationControllerInternal alloc] initWithRootViewController:controller];
        [self addChildViewController:self.containerNavigatioinController];
        [self.containerNavigatioinController didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.containerNavigatioinController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.containerNavigatioinController.view];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.containerNavigatioinController.view.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.contentViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return [self.contentViewController prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return [self.contentViewController preferredStatusBarUpdateAnimation];
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action
                                      fromViewController:(UIViewController *)fromViewController
                                              withSender:(id)sender
{
    if ([self.contentViewController respondsToSelector:action])
        return self.contentViewController;
    return nil;
}

@end

@implementation RTContainerNavigationControllerInternal

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action
                                      fromViewController:(UIViewController *)fromViewController
                                              withSender:(id)sender
{
    if (self.navigationController) {
        return [self.navigationController viewControllerForUnwindSegueAction:action
                                                          fromViewController:self.parentViewController
                                                                  withSender:sender];
    }
    return [super viewControllerForUnwindSegueAction:action
                                  fromViewController:fromViewController
                                          withSender:sender];
}

- (NSArray<UIViewController *> *)allowedChildViewControllersForUnwindingFromSource:(UIStoryboardUnwindSegueSource *)source
{
    if (self.navigationController) {
        return [self.navigationController allowedChildViewControllersForUnwindingFromSource:source];
    }
    return [super allowedChildViewControllersForUnwindingFromSource:source];
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController
                                             animated:animated];
    }
    else {
        [super pushViewController:viewController
                         animated:animated];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.navigationController respondsToSelector:aSelector])
        return self.navigationController;
    return nil;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.navigationController)
        return [self.navigationController popViewControllerAnimated:animated];
    return [super popViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (self.navigationController)
        return [self.navigationController popToRootViewControllerAnimated:animated];
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                     animated:(BOOL)animated
{
    if (self.navigationController)
        return [self.navigationController popToViewController:viewController
                                                     animated:animated];
    return [super popToViewController:viewController
                             animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    if (self.navigationController)
        [self.navigationController setViewControllers:viewControllers
                                             animated:animated];
    else
        [super setViewControllers:viewControllers animated:animated];
}

@end


@interface RTRootNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<UIGestureRecognizerDelegate> popGestureDelegate;
@property (nonatomic, copy) void(^animationBlock)(BOOL finished);
@end

@implementation RTRootNavigationController

#pragma mark - Methods

- (void)onBack:(id)sender
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Overrides

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewControllers = [super viewControllers];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:RTSafeWrapViewController(rootViewController)];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;
    self.navigationBarHidden = YES;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action
                                      fromViewController:(UIViewController *)fromViewController
                                              withSender:(id)sender
{
    UIViewController *controller = [super viewControllerForUnwindSegueAction:action
                                                          fromViewController:fromViewController
                                                                  withSender:sender];
    if (!controller) {
        NSInteger index = [self.viewControllers indexOfObject:fromViewController];
        if (index != NSNotFound) {
            for (NSInteger i = index - 1; i >= 0; --i) {
                controller = [self.viewControllers[i] viewControllerForUnwindSegueAction:action
                                                                      fromViewController:fromViewController
                                                                              withSender:sender];
                if (controller)
                    break;
            }
        }
    }
    return controller;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
    [super pushViewController:RTSafeWrapViewController(viewController)
                     animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return RTSafeUnwrapViewController([super popViewControllerAnimated:animated]);
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [[super popToRootViewControllerAnimated:animated] rt_map:^id(id obj) {
        return RTSafeUnwrapViewController(obj);
    }];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                     animated:(BOOL)animated
{
    __block UIViewController *controllerToPop = nil;
    [[super viewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * obj, NSUInteger idx, BOOL * stop) {
        if (RTSafeUnwrapViewController(obj) == viewController) {
            controllerToPop = obj;
            *stop = YES;
        }
    }];
    if (controllerToPop) {
        return [super popToViewController:controllerToPop
                                 animated:animated];
    }
    return nil;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated
{
    [super setViewControllers:[viewControllers rt_map:^id(id obj) {
        return RTSafeWrapViewController(obj);
    }]
                     animated:animated];
}

#pragma mark - Public Methods

- (UIViewController *)rt_topViewController
{
    return RTSafeUnwrapViewController([super topViewController]);
}

- (UIViewController *)rt_visibleViewController
{
    return RTSafeUnwrapViewController([super visibleViewController]);
}

- (NSArray <__kindof UIViewController *> *)rt_viewControllers
{
    return [[super viewControllers] rt_map:^id(id obj) {
        return RTSafeUnwrapViewController(obj);
    }];
}

- (void)removeViewController:(UIViewController *)controller
{
    NSMutableArray<__kindof UIViewController *> *controllers = [self.viewControllers mutableCopy];
    __block UIViewController *controllerToRemove = nil;
    [controllers enumerateObjectsUsingBlock:^(__kindof UIViewController * obj, NSUInteger idx, BOOL * stop) {
        if (RTSafeUnwrapViewController(obj) == controller) {
            controllerToRemove = obj;
            *stop = YES;
        }
    }];
    if (controllerToRemove) {
        [controllers removeObject:controllerToRemove];
        self.viewControllers = [NSArray arrayWithArray:controllers];
    }
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                  complete:(void (^)(BOOL))block
{
    if (self.animationBlock) {
        self.animationBlock(NO);
    }
    self.animationBlock = block;
    [self pushViewController:viewController
                    animated:animated];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    if (!isRootVC) {
        viewController = RTSafeUnwrapViewController(viewController);
        viewController.navigationItem.leftBarButtonItem = [viewController customBackItemWithTarget:self
                                                                                            action:@selector(onBack:)];
    }

    if ([self.rt_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.rt_delegate navigationController:navigationController
                        willShowViewController:viewController
                                      animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    viewController = RTSafeUnwrapViewController(viewController);
    if (viewController.rt_disableInteractivePop || viewController.navigationController.navigationBarHidden) {
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = !isRootVC;
    }

    if (self.animationBlock) {
        self.animationBlock(YES);
        self.animationBlock = nil;
    }

    if ([self.rt_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.rt_delegate navigationController:navigationController
                         didShowViewController:viewController
                                      animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{

    if ([self.rt_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.rt_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
{

    if ([self.rt_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.rt_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if ([self.rt_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.rt_delegate navigationController:navigationController
          interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([self.rt_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.rt_delegate navigationController:navigationController
                      animationControllerForOperation:operation
                                   fromViewController:fromVC
                                     toViewController:toVC];
    }
    return nil;
}



#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
