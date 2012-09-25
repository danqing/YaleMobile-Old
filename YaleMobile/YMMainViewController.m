//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMainViewController.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMGlobalHelper.h"

@interface YMMainViewController ()

@end

@implementation YMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name = @", Dan";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Slide view menu setup
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[YMMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    // Slide view gesture recognizer setup
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    
    // Slide view shadow setup
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    // Display different background and greeting depending on current time
    NSInteger hour = [YMGlobalHelper getCurrentTime];
    
    if (hour <= 2) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGDay-568h@2x.png"]]];
        else [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGDay.png"]]];
    } else {
        if ([[UIScreen mainScreen] bounds].size.height == 568) [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGNight-568h@2x.png"]]];
        else [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGNight.png"]]];
    }
    
    if (hour == 1) self.greeting.text = [NSString stringWithFormat:@"Good morning%@! It's a brand new day.", self.name];
    else if (hour == 2) self.greeting.text = [NSString stringWithFormat:@"Good afternoon%@!", self.name];
    else if (hour == 3) self.greeting.text = [NSString stringWithFormat:@"Good evening%@! Hope you've had a great day.", self.name];
    else self.greeting.text = [NSString stringWithFormat:@"Good night%@! Have some good rest :)", self.name];
    
}

@end
