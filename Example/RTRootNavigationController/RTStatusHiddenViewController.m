//
//  RTStatusHiddenViewController.m
//  RTRootNavigationController
//
//  Created by Ricky on 2017/8/3.
//  Copyright © 2017年 rickytan. All rights reserved.
//

#import "RTStatusHiddenViewController.h"

@interface RTStatusHiddenViewController ()

@end

@implementation RTStatusHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

@end
