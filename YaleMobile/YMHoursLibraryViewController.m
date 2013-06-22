//
//  YMHoursLibraryViewController.m
//  YaleMobile
//
//  Created by Danqing on 6/22/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMHoursLibraryViewController.h"
#import "YMGlobalHelper.h"
#import "YMSubtitleCell.h"

@interface YMHoursLibraryViewController ()

@end

@implementation YMHoursLibraryViewController

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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"sterling.jpeg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.alpha = 0.7;
    [self updateTableHeader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *cell = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
    if (fabsf(translation.x) > fabsf(translation.y)) return YES;
    return NO;
}

- (void)updateTableHeader
{
    float extra = ([[UIScreen mainScreen] bounds].size.height == 568) ? 292 : 204;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 140 + extra, 286, 28)];
    headerLabel.text = self.name;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.numberOfLines = 0;
    
    CGSize textSize = [self.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18] constrainedToSize:CGSizeMake(286.0, 3000)];
    CGRect newFrame = headerLabel.frame;
    newFrame.size.height = textSize.height;
    headerLabel.frame = newFrame;
    
    UILabel *headerSublabel = [[UILabel alloc] initWithFrame:CGRectMake(24, headerLabel.frame.size.height + extra + 140, 286, 25)];
    headerSublabel.textColor = [UIColor whiteColor];
    headerSublabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    headerSublabel.backgroundColor = [UIColor clearColor];
    headerSublabel.numberOfLines = 0;
    headerSublabel.text = [self.data objectForKey:@"address"];
    
    CGSize textSize2 = [[self.data objectForKey:@"address"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] constrainedToSize:CGSizeMake(286.0, 3000)];
    CGRect newFrame2 = headerSublabel.frame;
    newFrame2.size.height = textSize2.height;
    headerSublabel.frame = newFrame2;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150 + headerLabel.frame.size.height + headerSublabel.frame.size.height + extra)];

    [containerView addSubview:headerLabel];
    [containerView addSubview:headerSublabel];
    
    self.tableView.tableHeaderView = containerView;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSubtitleCell *cell;
    
    if (indexPath.row == 0) cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Library Cell 1"];
    else cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Library Cell 2"];
    
    cell.secondary.text = @"Hello there";
    cell.primary.text = @"Heyyyy~~";
    if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
    } else if (indexPath.row == 3) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
    
    cell.backgroundView.alpha = 0.4;
    cell.selectedBackgroundView.alpha = 0.6;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 3)
        return 71;
    else
        return 61;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
