//
//  YMDiningDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMDiningDetailViewController.h"
#import "YMDiningMenuViewController.h"
#import "YMServerCommunicator.h"
#import "YMGlobalHelper.h"
#import "YMSubtitleCell.h"

@interface YMDiningDetailViewController ()

@end

@implementation YMDiningDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    [YMGlobalHelper addBackButtonToController:self];
    [self updateTableHeader];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.abbr]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.alpha = 0.7;
    [self updateTableHeader];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    float height = ([[UIScreen mainScreen] bounds].size.height == 568) ? 548 : 460;
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    view.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_overlay.png", self.abbr]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view insertSubview:view belowSubview:self.tableView];
    self.overlay = view;
    view.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YMDiningMenuViewController *dmvc = (YMDiningMenuViewController *)segue.destinationViewController;
    //NSDictionary *info = [[NSDictionary alloc] initWithDictionary:[self.locations objectForKey:[self.sortedKeys objectAtIndex:self.selectedIndexPath.row]]];
    dmvc.title = self.title;
    dmvc.locationID = self.locationID;
    [YMServerCommunicator getDiningDetailForLocation:self.locationID forController:dmvc usingBlock:^(NSArray *array) {
        dmvc.data = array;
        [dmvc.tableView reloadData];
    }];
}

- (void)updateTableHeader
{
    float extra = ([[UIScreen mainScreen] bounds].size.height == 568) ? 336 : 248;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 140 + extra, 286, 28)];
    headerLabel.text = self.titleText;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.numberOfLines = 0;
    
    CGSize textSize = [self.titleText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18] constrainedToSize:CGSizeMake(286.0, 3000)];
    CGRect newFrame = headerLabel.frame;
    newFrame.size.height = textSize.height;
    headerLabel.frame = newFrame;
    
    UILabel *headerSublabel = [[UILabel alloc] initWithFrame:CGRectMake(24, headerLabel.frame.size.height + extra + 140, 286, 25)];
    headerSublabel.textColor = [UIColor whiteColor];
    headerSublabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    headerSublabel.backgroundColor = [UIColor clearColor];
    headerSublabel.numberOfLines = 0;
    headerSublabel.text = self.address;
    
    CGSize textSize2 = [self.address sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] constrainedToSize:CGSizeMake(286.0, 3000)];
    CGRect newFrame2 = headerSublabel.frame;
    newFrame2.size.height = textSize2.height;
    headerSublabel.frame = newFrame2;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150 + headerLabel.frame.size.height + headerSublabel.frame.size.height + extra)];
    
    [containerView addSubview:headerLabel];
    [containerView addSubview:headerSublabel];
    
    self.tableView.tableHeaderView = containerView;
    [self.tableView reloadData];    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    self.overlay.alpha = offset/400;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSubtitleCell *cell;

    if (indexPath.row == 0) cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Detail Cell 1"];
    else cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Detail Cell 2"];
    
    if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        cell.secondary.text = @"Regular Hours";
        cell.primary.text = self.hour;
        CGSize textSize = [self.hour sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
        CGRect frame = cell.primary.frame;
        frame.size.height = textSize.height;
    } else if (indexPath.row == 2) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.secondary.text = @"Menu";
        cell.primary.text = @"Click me to see today's menu";
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.secondary.text = @"Special Events";
        cell.primary.text = @"No upcoming special events";
    }
    
    cell.backgroundView.alpha = 0.4;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
        return 71;
    else if (indexPath.row == 1)
        return 61;
    else {
        CGSize textSize = [self.hour sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
        return textSize.height + 50;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Dining Menu Segue" sender:self];
}

@end
