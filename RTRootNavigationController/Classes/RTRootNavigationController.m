//
//  RTRootNavigationController.m
//  Pods
//
//  Created by ricky on 16/6/8.
//
//

#import "RTRootNavigationController.h"

#import "UIViewController+RTRootNavigationController.h"

@class RTContainerControllerInternal, RTContainerNavigationControllerInternal;


@interface NSArray (RTRootNavigationController)
- (NSArray *)rt_map:(id(^)(id))block;
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

@end

@implementation RTContainerNavigationControllerInternal

- (void)viewDidLoad
{
    [super viewDidLoad];
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
@end

@implementation RTRootNavigationController

#pragma mark - Methods

- (void)removeViewController:(UIViewController *)controller
{
    NSMutableArray *controllers = [self.rt_viewControllers mutableCopy];
    [controllers removeObject:controller];
    self.viewControllers = [NSArray arrayWithArray:controllers];
}

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
        return [super popToViewController:viewController
                                 animated:animated];
    }
    return nil;
}

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

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated
{
    [super setViewControllers:[viewControllers rt_map:^id(id obj) {
        return RTSafeWrapViewController(obj);
    }]
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
    return UIInterfaceOrientationMaskPortrait;
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
