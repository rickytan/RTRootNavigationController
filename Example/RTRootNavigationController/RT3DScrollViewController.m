//
//  RT3DScrollViewController.m
//  RTRootNavigationController
//
//  Created by ricky on 16/9/11.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import <JT3DScrollView/JT3DScrollView.h>

#import "RT3DScrollViewController.h"

@interface RT3DScrollViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet JT3DScrollView *scrollView;

@end

@implementation RT3DScrollViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.scrollView.effect = JT3DScrollViewEffectCards;

    self.scrollView.delegate = self; // Use only for animate nextButton and previousButton

    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
}

- (void)createCardWithColor
{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame);

    CGFloat x = self.scrollView.subviews.count * width;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.];

    view.layer.cornerRadius = 8.;

    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(x + width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
