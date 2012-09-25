//
//  YMGlobalHelper.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMGlobalHelper.h"

@implementation YMGlobalHelper

+ (NSInteger)getCurrentTime
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSInteger hour = [components hour];
    
    if (hour >= 6 && hour < 12) return 1;
    else if (hour >= 12 && hour < 18) return 2;
    else if (hour >= 18 && hour < 22) return 3;
    else return 4;
}

@end
