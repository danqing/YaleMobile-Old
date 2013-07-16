//
//  YMStopAnnotation.m
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMStopAnnotation.h"

@implementation YMStopAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
