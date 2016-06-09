//
//  RTPushRemoveViewController.m
//  RTRootNavigationController
//
//  Created by ricky on 16/6/9.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

#import "RTPushRemoveViewController.h"
#import "RTViewController.h"

@interface RTPushRemoveViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *animatedSwitch;

@end

@implementation RTPushRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPush:(id)sender {
    [self.rt_navigationController pushViewController:[[RTViewController alloc] init]
                                            animated:self.animatedSwitch.on
                                            complete:^(BOOL finished) {
                                                [self.rt_navigationController removeViewController:self];
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
