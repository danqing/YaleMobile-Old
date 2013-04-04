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
#import "YMSimpleCell.h"
#import "YMSubtitleCell.h"

@interface YMDiningDetailViewController ()

@end

@implementation YMDiningDetailViewController

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

- (void)updateTableHeader {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 140, 270, 28)];
    headerLabel.text = self.titleText;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.numberOfLines = 0;
    
    CGSize textSize = [self.titleText sizeWithFont:[UIFont boldSystemFontOfSize:19] constrainedToSize:CGSizeMake(270.0, 3000)];
    CGRect newFrame = headerLabel.frame;
    newFrame.size.height = textSize.height;
    headerLabel.frame = newFrame;
    
    UILabel *headerSublabel = [[UILabel alloc] initWithFrame:CGRectMake(30, headerLabel.frame.size.height + 140, 2780, 25)];
    headerSublabel.textColor = [UIColor whiteColor];
    headerSublabel.shadowColor = [UIColor blackColor];
    headerSublabel.shadowOffset = CGSizeMake(0, 1);
    headerSublabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    headerSublabel.backgroundColor = [UIColor clearColor];
    headerSublabel.numberOfLines = 0;
    headerSublabel.text = self.address;
    
    CGSize textSize2 = [self.address sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(270.0, 3000)];
    CGRect newFrame2 = headerSublabel.frame;
    newFrame2.size.height = textSize2.height;
    headerSublabel.frame = newFrame2;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160 + headerLabel.frame.size.height + headerSublabel.frame.size.height)];
    
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [shadow setImage:[UIImage imageNamed:@"dining_overlay.png"]];
    [containerView addSubview:shadow];
    [containerView addSubview:headerLabel];
    [containerView addSubview:headerSublabel];
    
    self.tableView.tableHeaderView = containerView;
    UIEdgeInsets imgInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    NSString *picture = [self.abbr stringByAppendingString:@".png"];
    UIImage *image = [[UIImage imageNamed:picture] resizableImageWithCapInsets:imgInsets];
    
    [containerView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Detail Menu Cell"];
    cell.name.text = @"View Menu";
    
    cell.name.shadowColor = [UIColor whiteColor];
    cell.name.shadowOffset = CGSizeMake(0, 1);
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)]];
    
    return cell;
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
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Dining Menu Segue" sender:self];
}

@end
