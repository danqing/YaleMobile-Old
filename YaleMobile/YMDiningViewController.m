//
//  YMDiningViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMDiningViewController.h"
#import "YMDiningDetailViewController.h"
#import "YMGlobalHelper.h"
#import "ECSlidingViewController.h"
#import "YMDiningCell.h"
#import "YMServerCommunicator.h"

@interface YMDiningViewController ()

@end

@implementation YMDiningViewController

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
    [YMGlobalHelper addMenuButtonToController:self];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plaintabletop.png"]];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Dining" ofType:@"plist"];
    self.locations = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.sortedKeys = [[self.locations allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [YMServerCommunicator getAllDiningStatusForController:self usingBlock:^(NSArray *array) {
        self.data = array;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.translucent = NO;
    [YMGlobalHelper setupSlidingViewControllerForController:self];
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *cell = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
    if (fabsf(translation.x) > fabsf(translation.y)) return YES;
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YMDiningDetailViewController *ddvc = (YMDiningDetailViewController *)segue.destinationViewController;
    NSDictionary *info = [[NSDictionary alloc] initWithDictionary:[self.locations objectForKey:[self.sortedKeys objectAtIndex:self.selectedIndexPath.row]]];
    ddvc.titleText = [info objectForKey:@"Name"];
    ddvc.abbr = [info objectForKey:@"Abbreviation"];
    ddvc.address = [info objectForKey:@"Location"];
    ddvc.locationID = [[[self.data objectAtIndex:self.selectedIndexPath.row] objectAtIndex:0] integerValue];
    ddvc.hour = [self parseHours:[info objectForKey:@"Hours"]];
}

- (NSString *)parseHours:(NSArray *)array
{
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSDictionary *entry in array) {
        [components addObject:[NSString stringWithFormat:@"%@\n\t\t\t\t› ", [[entry allKeys] objectAtIndex:0]]];
        [components addObject:[NSString stringWithFormat:@"%@\n", [[[entry allValues] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t\t\t› "]]];
    }
    return [components componentsJoinedByString:@""];
}

- (NSString *)crowdedness:(NSInteger)degree
{
    if (degree == 0) return @"Closed";
    if (degree == 1 || degree == 2) return @"Very Empty";
    if (degree == 3 || degree == 4) return @"Mostly Empty";
    if (degree == 5 || degree == 6) return @"Moderate";
    if (degree == 7 || degree == 8) return @"Mostly Full";
    else return @"Extremely Full";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMDiningCell *cell = (YMDiningCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Cell"];
    NSDictionary *info = [[NSDictionary alloc] initWithDictionary:[self.locations objectForKey:[self.sortedKeys objectAtIndex:indexPath.row]]];
    cell.name.text = [info objectForKey:@"Name"];
    cell.location.text = [info objectForKey:@"Location"];
    
    cell.name.shadowColor = [UIColor whiteColor];
    cell.name.shadowOffset = CGSizeMake(0, 1);
    cell.location.shadowColor = [UIColor whiteColor];
    cell.location.shadowOffset = CGSizeMake(0, 1);
    cell.special.shadowColor = [UIColor whiteColor];
    cell.special.shadowOffset = CGSizeMake(0, 1);
    cell.crowdLabel.shadowColor = [UIColor whiteColor];
    cell.crowdLabel.shadowOffset = CGSizeMake(0, 1);
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)]];
    
    cell.special.text = [[self.data objectAtIndex:indexPath.row] objectAtIndex:2];
    cell.crowdLabel.text = [self crowdedness:[[[self.data objectAtIndex:indexPath.row] objectAtIndex:4] integerValue]];
    cell.crowdedness.image = [UIImage imageNamed:[NSString stringWithFormat:@"dots%d.png", [[[self.data objectAtIndex:indexPath.row] objectAtIndex:4] integerValue] / 2]];
    if ([[[self.data objectAtIndex:indexPath.row] objectAtIndex:6] integerValue]) cell.crowdLabel.text = @"Closed";
        
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
    [self performSegueWithIdentifier:@"Dining Segue" sender:self];
}

@end
