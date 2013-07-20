//
//  YMCHelper.m
//  YaleMobile
//
//  Created by Danqing on 7/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMCHelper.h"

static inline double radians (double degrees) { return degrees * M_PI/180; }

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

CGMutablePathRef createShuttlePath(CGContextRef context, CGRect rect)
{
    CGFloat radius = 10;
    CGPoint center = CGPointMake(13, 13);
    CGPoint endpoint = CGPointMake(13, 40);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, radians(120), radians(60), 0);
    CGPathAddLineToPoint(path, NULL, endpoint.x, endpoint.y);
    CGPathCloseSubpath(path);
    
    return path;
}