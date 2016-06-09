//
//  RTItemListViewController.m
//  RTRootNavigationController
//
//  Created by ricky on 16/6/9.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

#import "RTItemListViewController.h"
#import "RTItemDetailViewController.h"

@interface RTItemListViewController () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation RTItemListViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = CGSizeMake((self.view.bounds.size.width - 10 * 3) / 2, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.navigationController.delegate = self;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark - UINavigationController Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return self;
    return nil;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return UINavigationControllerHideShowBarDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    RTContainerController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    RTContainerController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [containerView addSubview:toVC.view];

    // following is required!
    [containerView setNeedsLayout];
    [containerView layoutIfNeeded];

    toVC.view.alpha = 0.f;

    NSIndexPath *selected = ((RTItemListViewController *)fromVC.contentViewController).collectionView.indexPathsForSelectedItems.firstObject;
    UICollectionViewCell *cell = [((RTItemListViewController *)fromVC.contentViewController).collectionView cellForItemAtIndexPath:selected];
    CGRect frame = [toVC.contentViewController.view convertRect:cell.frame
                                                       fromView:cell.superview];
    CGRect finalFrame = ((RTItemDetailViewController *)toVC.contentViewController).itemImageView.frame;
    ((RTItemDetailViewController *)toVC.contentViewController).itemImageView.frame = frame;
    [UIView transitionWithView:containerView
                      duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        toVC.view.alpha = 1.f;
                        ((RTItemDetailViewController *)toVC.contentViewController).itemImageView.frame = finalFrame;
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view removeFromSuperview];
                        }
                        [transitionContext completeTransition:finished];
                    }];
}

@end
