//
//  YMAcademicCalendarDetailViewController.h
//  YaleMobile
//
//  Created by iBlue on 12/28/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMAcademicCalendarDetailViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *calendar;
@property (nonatomic, strong) NSArray *terms;
@property (nonatomic, strong) NSArray *sorted;

@end
