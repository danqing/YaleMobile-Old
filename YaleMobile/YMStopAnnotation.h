//
//  YMStopAnnotation.h
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YMStopAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSArray *routes;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
