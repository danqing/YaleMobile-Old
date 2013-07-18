//
//  YMStopAnnotation.m
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMStopAnnotation.h"

@implementation YMStopAnnotation

@synthesize coordinate, routes, title, subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord routes:(NSArray *)rs title:(NSString *)t andSubtitle:(NSString *)st
{
    self = [super init];
    if (self) {
        coordinate = coord;
        routes = rs;
        title = t;
        subtitle = st;
    }
    return self;
}

@end
