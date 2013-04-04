//
//  YMMapViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMapViewController.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMGlobalHelper.h"

@interface YMMapViewController ()

@end

@implementation YMMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 700)];
    self.searchOverlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mapoverlay.png"]];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 22)];
    [menu setBackgroundImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:menu]];
    
    UIButton *locate = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 23)];
    [locate setBackgroundImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [locate addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:locate]];
    self.locate = locate;
    self.locating = 0;
    
    self.detailView.layer.shadowOpacity = 0.5f;
    self.detailView.layer.shadowRadius = 3.0f;
    self.detailView.layer.shadowColor = [UIColor lightGrayColor].CGColor;

}

- (void)viewWillAppear:(BOOL)animated {
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[YMMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.3123;
    zoomLocation.longitude = -72.9281;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation, span);
    [self.mapView setRegion:region animated:YES];
    
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
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

- (void)locate:(id)sender
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied" message:@"Location service is turned off for YaleMobile. If you would like to grant YaleMobile access, please go to Settings - Location Services." delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.locating) {
        self.locating = 0;
        self.mapView.showsUserLocation = NO;
    } else {
        self.locating = 1;
        self.mapView.showsUserLocation = YES;
    }
}

# pragma mark - mapview methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.locating == 1) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        self.locating = 2;
    }
}

- (void)zoomMapAndCenterAtLatitude:(double)latitude andLongitude:(double)longitude {
    MKCoordinateRegion region;
    region.center.latitude  = latitude;
    region.center.longitude = longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = .020;
    span.longitudeDelta = .020;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

# pragma mark - search bar methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    self.searchOverlay.alpha = 0;
    [self.view addSubview:self.searchOverlay];
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchOverlay.alpha = 1;
    [UIView commitAnimations];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self hideKeyboard];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [UIView beginAnimations:@"FadeOut" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchOverlay.alpha = 0;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(removeOverlay:) userInfo:nil repeats:NO];
    
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)removeOverlay:(NSTimer *)timer
{
    [self.searchOverlay removeFromSuperview];
}

@end
