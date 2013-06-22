//
//  Route+Initialize.m
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "Route+Initialize.h"

@implementation Route (Initialize)

+ (void)routeWithData:(NSDictionary *)data forTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    Route *route = nil;
    
    NSInteger routeId = [[data objectForKey:@"route_id"] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    request.predicate = [NSPredicate predicateWithFormat:@"routeid = %d", routeId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return;
    else if (matches.count == 0) route = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:context];
    else route = [matches lastObject];
    
    route.routeid = [NSNumber numberWithInteger:routeId];
    route.name = [data objectForKey:@"long_name"];
    route.color = [data objectForKey:@"color"];
    route.timestamp = [NSNumber numberWithDouble:timestamp];
    if (![route.inactive boolValue]) route.inactive = NO;
}

+ (Route *)fetchRouteWithId:(NSNumber *)routeId inManagedObjectContext:(NSManagedObjectContext *)context
{
    Route *route = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    request.predicate = [NSPredicate predicateWithFormat:@"routeid = %d", routeId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) return nil;
    else if (matches.count == 0) route = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:context];
    else route = [matches lastObject];
    
    return route;
}

+ (void)removeAllRoutesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Removing all routes.....");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    for (Route *route in matches) [context deleteObject:route];
}

+ (void)removeRoutesBeforeTimestamp:(NSTimeInterval)timestamp inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeid" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"timestamp != %f", timestamp];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"Removing routes with timestamp %f. Matches: %d", timestamp, matches.count);
    for (Route *route in matches) [context deleteObject:route];
}

@end
