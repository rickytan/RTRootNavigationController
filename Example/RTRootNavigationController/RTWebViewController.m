//
//  RTWebViewController.m
//  RTRootNavigationController
//
//  Created by ricky on 16/6/10.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

#import "RTWebViewController.h"

@interface RTWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *indicateLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerView;
@end

@implementation RTWebViewController

- (void)loadView
{
    [super loadView];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    self.indicateLabel = [[UILabel alloc] init];
    self.indicateLabel.font = [UIFont systemFontOfSize:14.f];
    self.indicateLabel.textColor = [UIColor whiteColor];
    self.indicateLabel.numberOfLines = 2;
    self.indicateLabel.textAlignment = NSTextAlignmentCenter;
    self.indicateLabel.text = @"Site provided by:\n";
    [self.indicateLabel sizeToFit];
    self.indicateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.webView insertSubview:self.indicateLabel
                        atIndex:0];

    [self.webView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.indicateLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.webView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:16.f],
                                   [NSLayoutConstraint constraintWithItem:self.indicateLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.webView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.f]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.translucent = NO;

    self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinnerView];
    
    UIBarButtonItem *backward = [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(onBackward:)];
    backward.enabled = NO;
    UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithTitle:@">"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(onForward:)];
    forward.enabled = NO;
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                             target:self
                                                                             action:@selector(onRefresh:)];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(onShare:)];
    self.toolbarItems = @[backward,
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                        target:nil
                                                                        action:NULL],
                          forward,
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                        target:nil
                                                                        action:NULL],
                          refresh,
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                        target:nil
                                                                        action:NULL],
                          share];


    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com"]]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackward:(id)sender
{
    [self.webView goBack];
}

- (void)onForward:(id)sender
{
    [self.webView goForward];
}

- (void)onRefresh:(id)sender
{
    [self.webView reload];
}

- (void)onShare:(id)sender
{

}

- (IBAction)onToggleToolbar:(id)sender {
    [self.navigationController setToolbarHidden:!self.navigationController.isToolbarHidden
                                       animated:YES];
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinnerView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinnerView stopAnimating];
    self.indicateLabel.text = [NSString stringWithFormat:@"Site provided by:\n%@", webView.request.URL.host];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    self.toolbarItems[0].enabled = webView.canGoBack;
    self.toolbarItems[2].enabled = webView.canGoForward;
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [self.spinnerView stopAnimating];
}

@end
