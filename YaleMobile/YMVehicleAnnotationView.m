//
//  YMVehicleAnnotationView.m
//  YaleMobile
//
//  Created by Danqing on 7/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMVehicleAnnotationView.h"
#import "YMVehicleAnnotation.h"
#import "YMGlobalHelper.h"
#import "YMCHelper.h"
#import "Vehicle.h"
#import "Route.h"

@implementation YMVehicleAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect f = self.frame;
        f.size.width = 25;
        f.size.height = 40;
        self.frame = f;
        self.opaque = NO;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *color = [YMGlobalHelper colorFromHexString:((YMVehicleAnnotation *)self.annotation).vehicle.route.color];
    UIColor *fillColor = [color colorWithAlphaComponent:0.7];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 3);
    
    CGMutablePathRef ref = createShuttlePath(context, self.bounds);
    CGContextAddPath(context, ref);
    
    CGContextStrokePath(context);
    CGContextFillPath(context);
    
    CFRelease(ref);
}

@end
