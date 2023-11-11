//
//  RTMultipleRemoveViewController.m
//  RTRootNavigationController_Example
//
//  Created by yu yang on 2019/5/16.
//  Copyright © 2019 rickytan. All rights reserved.
//

#import "RTMultipleRemoveViewController.h"
#import "RTViewController.h"
#import <RTRootNavigationController/RTRootNavigationController.h>

@interface RTMultipleRemoveViewController ()

@end

@implementation RTMultipleRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onPush:(id)sender {
    [self.rt_navigationController pushViewController:[[RTViewController alloc] init]
                                            animated:YES
                                            complete:^(BOOL finished) {
                                                UIViewController *previous = self.rt_navigationController.rt_viewControllers[self.rt_navigationController.rt_viewControllers.count - 3];
                                                [self.rt_navigationController removeViewControllers:@[self, previous]];
                                            }];
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
