//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMMainViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *temperature;
@property (nonatomic, strong) IBOutlet UILabel *condition;
@property (nonatomic, strong) IBOutlet UILabel *greeting;
@property (nonatomic, strong) IBOutlet UIImageView *weather;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) IBOutlet UILabel *day1;
@property (nonatomic, strong) IBOutlet UIImageView *weather1;
@property (nonatomic, strong) IBOutlet UILabel *temp1;
@property (nonatomic, strong) IBOutlet UILabel *day2;
@property (nonatomic, strong) IBOutlet UIImageView *weather2;
@property (nonatomic, strong) IBOutlet UILabel *temp2;
@property (nonatomic, strong) IBOutlet UILabel *day3;
@property (nonatomic, strong) IBOutlet UIImageView *weather3;
@property (nonatomic, strong) IBOutlet UILabel *temp3;
@property (nonatomic, strong) IBOutlet UILabel *day4;
@property (nonatomic, strong) IBOutlet UIImageView *weather4;
@property (nonatomic, strong) IBOutlet UILabel *temp4;
@property (nonatomic, strong) IBOutlet UILabel *day5;
@property (nonatomic, strong) IBOutlet UIImageView *weather5;
@property (nonatomic, strong) IBOutlet UILabel *temp5;

@end
