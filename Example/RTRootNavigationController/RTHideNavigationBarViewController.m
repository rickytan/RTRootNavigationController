//
//  RTHideNavigationBarViewController.m
//  RTRootNavigationController
//
//  Created by ricky on 16/6/9.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

#import "RTHideNavigationBarViewController.h"
#import "RTCollectionViewController.h"

@interface RTHideNavigationBarViewController ()

@end

@implementation RTHideNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
#if RT_INTERACTIVE_PUSH
    self.rt_navigationController.rt_enableInteractivePush = YES;
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#if RT_INTERACTIVE_PUSH
- (UIViewController *)rt_nextSiblingController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"Scroll"];
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    return @[[UIPreviewAction actionWithTitle:@"Default"
                               style:UIPreviewActionStyleDefault
                                      handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                   
                               }],
             [UIPreviewAction actionWithTitle:@"Selected"
                                        style:UIPreviewActionStyleSelected
                                      handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                          
                                      }],
             [UIPreviewAction actionWithTitle:@"Destructive"
                                        style:UIPreviewActionStyleDestructive
                                      handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                          
                                      }]
             ];
}

@end
