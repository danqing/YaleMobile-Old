//
//  YMDiningMenuViewController.m
//  YaleMobile
//
//  Created by Danqing on 3/25/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMDiningMenuViewController.h"
#import "YMGlobalHelper.h"
#import "UIImage+Emboss.h"
#import "UIColor+YaleMobile.h"

@interface YMDiningMenuViewController ()

@end

@implementation YMDiningMenuViewController

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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plaintabletop.png"]];
    [YMGlobalHelper addBackButtonToController:self];
    [self updateTableHeader];
}

- (void)back:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableHeader
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 280, 28)];
    NSString *string = self.title;
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize textSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(280, 5000)];
    CGRect newFrame = imageView.frame;
    newFrame.size.height = textSize.height;
    imageView.frame = newFrame;
    UIImage *interior = [UIImage imageWithInteriorShadowAndString:string font:font textColor:[UIColor YMBluebookBlue] size:imageView.bounds.size];
    UIImage *image = [UIImage imageWithUpwardShadowAndImage:interior];
    imageView.image = image;
    
    UIImageView *subtitleView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20 + imageView.frame.size.height, 280, 30)];
    NSString *subtitleString = @"Today's Menu";
    UIFont *subtitleFont = [UIFont systemFontOfSize:15];
    CGSize subTextSize = [subtitleString sizeWithFont:subtitleFont constrainedToSize:CGSizeMake(280, 5000)];
    CGRect newSubFrame = subtitleView.frame;
    newSubFrame.size.height = subTextSize.height;
    subtitleView.frame = newSubFrame;
    UIImage *subIntererior = [UIImage imageWithInteriorShadowAndString:subtitleString font:subtitleFont textColor:[UIColor colorWithRed:111/255.0 green:132/255.0 blue:132/255.0 alpha:0.8] size:subtitleView.bounds.size];
    UIImage *subtitleImage = [UIImage imageWithUpwardShadowAndImage:subIntererior];
    subtitleView.image = subtitleImage;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, imageView.frame.size.height + subtitleView.frame.size.height + 75)];

    
    [containerView addSubview:imageView];
    [containerView addSubview:subtitleView];
    self.tableView.tableHeaderView = containerView;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Count is %d", self.data.count);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
