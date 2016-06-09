//
//  RTCustomNavigationBar.m
//  RTRootNavigationController
//
//  Created by ricky on 16/6/9.
//  Copyright © 2016年 rickytan. All rights reserved.
//

#import "RTCustomNavigationBar.h"

@implementation RTCustomNavigationBar

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    bezierPath.lineWidth = 4.f;
    [[UIColor orangeColor] setStroke];
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    [bezierPath stroke];
}

@end
