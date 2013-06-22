//
//  YMRoundView.m
//  YaleMobile
//
//  Created by Danqing on 6/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMRoundView.h"

@interface YMRoundView ()

@property (nonatomic, strong) UIColor *color;

@end

@implementation YMRoundView

- (id)initWithColor:(UIColor *)color andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.color = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *lightColor = [self.color colorWithAlphaComponent:0.6];
    UIColor *darkColor = self.color;
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, darkColor.CGColor, lightColor.CGColor);
}

@end
