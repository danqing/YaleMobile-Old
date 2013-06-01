//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMainViewController.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMGlobalHelper.h"
#import "YMServerCommunicator.h"

@interface YMMainViewController ()

@end

@implementation YMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    self.name = (name) ? [NSString stringWithFormat:@", %@", name] : @"";
    [YMGlobalHelper setupUserDefaults];    
    [YMGlobalHelper addMenuButtonToController:self];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [YMGlobalHelper setupSlidingViewControllerForController:self];
    [YMServerCommunicator getWeatherForController:self usingBlock:^(NSArray *array) {
        NSDictionary *current = [array objectAtIndex:0];
        self.temperature.text = ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"]) ? [NSString stringWithFormat:@"%@°C",[current objectForKey:@"temp"]] : [NSString stringWithFormat:@"%@°F",[current objectForKey:@"temp"]];
        self.condition.text = [NSString stringWithFormat:@"%@ and", [current objectForKey:@"text"]];
        self.weather.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[current objectForKey:@"code"] integerValue]]];
        
        NSLog(@"code is %@", [current objectForKey:@"code"]);
        
        NSDictionary *day1 = [array objectAtIndex:1];
        self.day1.text = [day1 objectForKey:@"day"];
        self.temp1.text = [NSString stringWithFormat:@"%@/%@", [day1 objectForKey:@"high"], [day1 objectForKey:@"low"]];
        self.weather1.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day1 objectForKey:@"code"] integerValue]]];

        NSDictionary *day2 = [array objectAtIndex:2];
        self.day2.text = [day2 objectForKey:@"day"];
        self.temp2.text = [NSString stringWithFormat:@"%@/%@", [day2 objectForKey:@"high"], [day2 objectForKey:@"low"]];
        self.weather2.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day2 objectForKey:@"code"] integerValue]]];

        /*NSDictionary *day3 = [array objectAtIndex:3];
        self.day3.text = [day3 objectForKey:@"day"];
        self.temp3.text = [NSString stringWithFormat:@"%@/%@", [day3 objectForKey:@"high"], [day3 objectForKey:@"low"]];
        self.weather3.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day3 objectForKey:@"code"] integerValue]]];

        NSDictionary *day4 = [array objectAtIndex:4];
        self.day4.text = [day4 objectForKey:@"day"];
        self.temp4.text = [NSString stringWithFormat:@"%@/%@", [day4 objectForKey:@"high"], [day4 objectForKey:@"low"]];
        self.weather4.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day4 objectForKey:@"code"] integerValue]]];

        NSDictionary *day5 = [array objectAtIndex:5];
        self.day5.text = [day5 objectForKey:@"day"];
        self.temp5.text = [NSString stringWithFormat:@"%@/%@", [day5 objectForKey:@"high"], [day5 objectForKey:@"low"]];
        self.weather5.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day5 objectForKey:@"code"] integerValue]]];*/

        NSString *overlay = [YMGlobalHelper getBgNameForWeather:[[current objectForKey:@"code"] integerValue]];
        if (overlay.length) {
            UIImageView *layer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:overlay]];
            layer.alpha = 0.8;
            [self.view addSubview:layer];
        }
    }];

    
    // Display different background and greeting depending on current time
    NSInteger hour = [YMGlobalHelper getCurrentTime];
    
    if (hour <= 2) {
        // if ([[UIScreen mainScreen] bounds].size.height == 568) [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGDay-568h@2x.png"]]];
        // else [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGDay.png"]]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    } else {
        // if ([[UIScreen mainScreen] bounds].size.height == 568) [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGNight-568h@2x.png"]]];
        // else [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGNight.png"]]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }
    
    if (hour == 1) self.greeting.text = [NSString stringWithFormat:@"Good morning%@! It's a brand new day.", self.name];
    else if (hour == 2) self.greeting.text = [NSString stringWithFormat:@"Good afternoon%@! Hope you are enjoying your day :)", self.name];
    else if (hour == 3) self.greeting.text = [NSString stringWithFormat:@"Good evening%@! Hope you've had a great day.", self.name];
    else self.greeting.text = [NSString stringWithFormat:@"Good night%@! Have some good rest :)", self.name];
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

@end
