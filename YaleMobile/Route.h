//
//  Route.h
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Segment, Stop;

@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * routeid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * inactive;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSSet *stops;
@property (nonatomic, retain) NSSet *segments;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addStopsObject:(Stop *)value;
- (void)removeStopsObject:(Stop *)value;
- (void)addStops:(NSSet *)values;
- (void)removeStops:(NSSet *)values;

- (void)addSegmentsObject:(Segment *)value;
- (void)removeSegmentsObject:(Segment *)value;
- (void)addSegments:(NSSet *)values;
- (void)removeSegments:(NSSet *)values;

@end
