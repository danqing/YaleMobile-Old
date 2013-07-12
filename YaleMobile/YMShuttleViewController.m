//
//  YMShuttleViewController.m
//  YaleMobile
//
//  Created by iBlue on 12/27/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

// Yale = 132

#import "YMShuttleViewController.h"
#import "YMGlobalHelper.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMShuttleSelectionViewController.h"
#import "YMServerCommunicator.h"
#import "Route+Initialize.h"
#import "Stop+Initialize.h"
#import "Segment+Initialize.h"
#import "YMDatabaseHelper.h"
#import "MKPolyline+EncodedString.h"

@interface YMShuttleViewController ()

@end

@implementation YMShuttleViewController

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
    [YMGlobalHelper addMenuButtonToController:self];
    
    UIButton *settings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 25)];
    [settings setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:settings]];
    [settings addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[YMMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [YMGlobalHelper setupRightSlidingViewControllerForController:self withRightController:[YMShuttleSelectionViewController class] named:@"Shuttle Selection"];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.3123;
    zoomLocation.longitude = -72.9281;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation, span);
    [self.mapView setRegion:region animated:YES];
    
    if ((self.db = [YMDatabaseHelper getManagedDocument]))
        [self loadData];
    else {
        [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {
            self.db = document;
            [YMDatabaseHelper setManagedDocumentTo:document];
            [self loadData];
        }];
    }
}

- (void)loadData
{
    NSTimeInterval interval = [YMGlobalHelper getTimestamp];
    [Route removeRoutesBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [YMServerCommunicator getRouteInfoForController:self usingBlock:^(NSArray *data) {
        for (NSDictionary *dict in data)
            [Route routeWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
        [YMServerCommunicator getStopInfoForController:self usingBlock:^(NSArray *data) {
            for (NSDictionary *dict in data)
                [Stop stopWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
            [YMServerCommunicator getSegmentInfoForController:self usingBlock:^(NSDictionary *data) {
                for (NSString *key in [data allKeys])
                    [Segment segmentWithID:[key integerValue] andEncodedString:[data objectForKey:key] inManagedObjectContext:self.db.managedObjectContext];
                [self refreshMap];
            }];
        }];
    }];
}

- (void)refreshMap
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [self.db.managedObjectContext executeFetchRequest:request error:&error];
    for (Segment *s in matches) {
        MKPolyline *line = [MKPolyline polylineWithEncodedString:s.string];
        [self.mapView addOverlay:line];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay];
        lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
        lineview.lineWidth=2.0;
        return lineview;
    }
    return nil;
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

- (void)settings:(id)sender
{
    self.slidingViewController.anchorLeftRevealAmount = 280.0f;
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

@end
