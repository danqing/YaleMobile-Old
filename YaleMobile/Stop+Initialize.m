//
//  Stop+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Stop+Initialize.h"
#import "Route+Initialize.h"

@implementation Stop (Initialize)

+ (void)stopWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    Stop *stop = nil;
    
    NSInteger stopId = [[data objectForKey:@"stop_id"] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    request.predicate = [NSPredicate predicateWithFormat:@"stopid = %d", stopId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"stopid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return;
    else if (matches.count == 0) stop = [NSEntityDescription insertNewObjectForEntityForName:@"Stop" inManagedObjectContext:context];
    else stop = [matches lastObject];
    
    stop.stopid = [NSNumber numberWithInteger:stopId];
    stop.name = [data objectForKey:@"name"];
    stop.latitude = [[data objectForKey:@"location"] objectForKey:@"lat"];
    stop.longitude = [[data objectForKey:@"location"] objectForKey:@"lng"];
    stop.timestamp = [NSNumber numberWithDouble:timestamp];
    
    NSArray *routes = [data objectForKey:@"routes"];
    NSMutableSet *routesSet = [[NSMutableSet alloc] initWithCapacity:routes.count];
    for (NSString *route in routes) {
        NSNumber *routeId = [NSNumber numberWithInteger:route.integerValue];
        Route *route = [Route fetchRouteWithId:routeId inManagedObjectContext:context];
        if (route) [routesSet addObject:route];
    }
    stop.routes = routesSet;
}

+ (void)removeAllStopsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Removing all stops.....");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"stopid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for (Stop *stop in matches) [context deleteObject:stop];
}

+ (void)removeStopsBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"stopid" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"timestamp != %f", timestamp];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"Removing stops with timestamp %f. Matches: %d", timestamp, matches.count);
    for (Stop *stop in matches) [context deleteObject:stop];
}

@end
