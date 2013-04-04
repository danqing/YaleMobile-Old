//
//  YMLaundryDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 12/28/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMLaundryDetailViewController.h"
#import "YMServerCommunicator.h"
#import "YMGlobalHelper.h"
#import "YMSimpleCell.h"
#import "YMLaundryDetailCell.h"
#import "UIColor+YaleMobile.h"

@interface YMLaundryDetailViewController ()

@end

@implementation YMLaundryDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YMGlobalHelper addBackButtonToController:self];
    self.washers = nil;
    self.dryers = nil;
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refresh];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh
{
    [YMServerCommunicator getLaundryStatusForLocation:self.roomCode forController:self usingBlock:^(NSArray *washers, NSArray *dryers, NSArray *machineStatuses) {
        self.washers = washers;
        self.dryers = dryers;
        self.machineStatuses = machineStatuses;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return (self.washers != nil) ? ([[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue] + 1) : 0;
    else
        return (self.dryers != nil) ? ([[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue] + 1) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Detail Header"];
        cell.name.text = (indexPath.section == 0) ? [NSString stringWithFormat:@"Washers: %@ of %@ available", [self.washers objectAtIndex:0], [self.washers objectAtIndex:1]] : [NSString stringWithFormat:@"Dryers: %@ of %@ available", [self.dryers objectAtIndex:0], [self.dryers objectAtIndex:1]];
        return cell;
    }
    
    YMLaundryDetailCell *cell;
    cell = (indexPath.row == 1) ? (YMLaundryDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Detail Cell Top"] : (YMLaundryDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Detail Cell Top"];
    
    NSUInteger index = indexPath.section * [[self.washers objectAtIndex:1] integerValue] + indexPath.row - 1;
    
    cell.machineID.text = [NSString stringWithFormat:@"#%@", [[(NSDictionary *)[self.machineStatuses objectAtIndex:index] allKeys] objectAtIndex:0]];
    NSString *status = [[(NSDictionary *)[self.machineStatuses objectAtIndex:index] allValues] objectAtIndex:0];
    
    [cell.time setHidden:true]; [cell.min setHidden:true]; [cell.status setHidden:false];
    
    if ([status rangeOfString:@"available"].location != NSNotFound) {
        cell.status.text = @"Available";
        cell.status.textColor = [UIColor colorWithRed:0.5 green:0.85 blue:0.2 alpha:1];
    } else if ([status rangeOfString:@"cycle has ended"].location != NSNotFound) {
        cell.status.text = @"Cycle has ended";
        cell.status.textColor = [UIColor YMLightOrange];
    } else if ([status rangeOfString:@"extended cycle"].location != NSNotFound) {
        cell.status.text = @"Running\nExtended cycle";
        cell.status.textColor = [UIColor colorWithRed:229/255.0 green:73/255.0 blue:45/255.0 alpha:1];
    } else if ([status rangeOfString:@"est. time"].location != NSNotFound) {
        cell.status.text = @"minutes left";
        cell.status.textColor = [UIColor grayColor];
        NSString *time = [status stringByReplacingOccurrencesOfString:@"est. time remaining" withString:@""];
        time = [time stringByReplacingOccurrencesOfString:@"min" withString:@""];
        cell.time.text = time;
        [cell.time setHidden:false];
        [cell.min setHidden:false];
        [cell.status setHidden:true];
    } else if ([status rangeOfString:@"out of service"].location != NSNotFound) {
        cell.status.text = @"Out of Service";
        cell.status.textColor = [UIColor grayColor];
    } else {
        cell.status.text = @"Status Unknown";
        cell.status.textColor = [UIColor grayColor];
    }
    
    if (indexPath.row == 1) {
        if ((indexPath.section == 0 && indexPath.row == [[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue]) ||
            (indexPath.section == 1 && indexPath.row == [[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue])) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        } else {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        }
    } else if ((indexPath.section == 0 && indexPath.row == [[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue]) ||
               (indexPath.section == 1 && indexPath.row == [[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue])) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 38;
    else if (indexPath.row == 1) return 66;
    else if ((indexPath.section == 0 && indexPath.row == [[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue]) ||
             (indexPath.section == 1 && indexPath.row == [[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue])) return 64;
    else return 56;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
