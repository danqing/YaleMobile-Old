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
#import "YMStopAnnotation.h"
#import "YMStopAnnotationView.h"
#import "YMTransferStopAnnotationView.h"
#import "YMStopInfoSubview.h"
#import "YMRoundView.h"

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
    self.zoomLevel = 0;
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
    [Stop removeStopsBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [Segment removeSegmentsBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    
    [YMServerCommunicator getRouteInfoForController:self usingBlock:^(NSArray *data) {
        for (NSDictionary *dict in data)
            [Route routeWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
        [YMServerCommunicator getStopInfoForController:self usingBlock:^(NSArray *data) {
            for (NSDictionary *dict in data)
                [Stop stopWithData:dict forTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
            [YMServerCommunicator getSegmentInfoForController:self usingBlock:^(NSDictionary *data) {
                for (NSString *key in [data allKeys])
                    [Segment segmentWithID:[key integerValue] andEncodedString:[data objectForKey:key] inManagedObjectContext:self.db.managedObjectContext];
                [self addSegments];
                [self addStops];
            }];
        }];
    }];
}

- (void)addSegments
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [self.db.managedObjectContext executeFetchRequest:request error:&error];
     
    for (Segment *s in matches) {
        NSArray *routes = [s.routes allObjects];
        for (Route *r in routes) {
            MKPolyline *line = [MKPolyline polylineWithEncodedString:s.string];
            line.title = r.color;
            line.subtitle = [NSString stringWithFormat:@"%d:%d", [routes indexOfObject:r], routes.count];
            [self.mapView addOverlay:line];
        }
    }
}

- (void)addStops
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"stopid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    NSArray *matches = [self.db.managedObjectContext executeFetchRequest:request error:&error];
    
    for (Stop *s in matches) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(s.latitude.doubleValue, s.longitude.doubleValue);
        YMStopAnnotation *annotation = [[YMStopAnnotation alloc] initWithLocation:coordinate routes:[s.routes allObjects] title:s.name andSubtitle:s.code.stringValue];
        [self.mapView addAnnotation:annotation];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        lineView.strokeColor = [[YMGlobalHelper colorFromHexString:overlay.title] colorWithAlphaComponent:1];
        lineView.lineWidth = 5.0;
        
        NSArray *routes = [overlay.subtitle componentsSeparatedByString:@":"];
        NSInteger routesCount = [[routes objectAtIndex:1] integerValue];
        if (routesCount > 1) {
            lineView.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:30 * ([[routes objectAtIndex:1] integerValue] - 1)], nil];
            lineView.lineDashPhase = [[routes objectAtIndex:0] floatValue] * 30;
        }
        return lineView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    if ([annotation isKindOfClass:[YMStopAnnotation class]]) {
        MKAnnotationView *stopView = nil;
        if (((YMStopAnnotation *) annotation).routes.count == 1) {
            stopView = (YMStopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Stop View"];
            if (!stopView) stopView = [[YMStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Stop View"];
            else stopView.annotation = annotation;
        } else {
            stopView = (YMTransferStopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Transfer View"];
            if (!stopView) stopView = [[YMTransferStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Transfer View"];
            else stopView.annotation = annotation;
        }
        stopView.canShowCallout = NO;
        [stopView setNeedsDisplay];
        return stopView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    double span = mapView.region.span.longitudeDelta;
    if (span > 0.02 && self.zoomLevel <= 0.02) {
        for (int i = mapView.annotations.count - 1; i >= 0; i--) {
            if ([[mapView.annotations objectAtIndex:i] isKindOfClass:[YMStopAnnotation class]])
                [mapView removeAnnotation:[mapView.annotations objectAtIndex:i]];
        }
    } else if (span <= 0.02 && self.zoomLevel > 0.02) {
        [self addStops];
    }
    self.zoomLevel = span;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[YMStopAnnotationView class]] || [view isKindOfClass:[YMTransferStopAnnotationView class]]) {
        YMStopInfoSubview *stopView = nil;
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YMStopInfoSubview" owner:self options:nil];
        for (id v in views) {
            if ([v isKindOfClass:[YMStopInfoSubview class]]) {
                stopView = (YMStopInfoSubview *)v;
                stopView.minutes.text = @"20";
                stopView.lineName.text = ((Route *)[((YMStopAnnotation *)view.annotation).routes objectAtIndex:0]).name;
                stopView.stopName.text = ((YMStopAnnotation *)view.annotation).title;
                stopView.stopCode.text = ((YMStopAnnotation *)view.annotation).subtitle;
                YMRoundView *roundView = [[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:((Route *)[((YMStopAnnotation *)view.annotation).routes objectAtIndex:0]).color] andFrame:CGRectMake(26, 43, 13, 13)];
                [stopView addSubview:roundView];
            }
        }
        
        float delay = 0;
        if (self.callout) {
            delay = 0.3;
            CGRect frame = self.callout.frame;
            frame.origin.y -= 100;
            [UIView animateWithDuration:0.3 animations:^{
                self.callout.frame = frame;
            } completion:^(BOOL finished) {
                [self removeCalloutView];
            }];
        }
        
        [self.view addSubview:stopView];
        CGRect frame = stopView.frame;
        frame.origin.y -= 100;
        stopView.frame = frame;
        frame.origin.y += 100;
        
        [UIView animateWithDuration:0.3 delay:delay options:nil animations:^{
            stopView.frame = frame;
        } completion:^(BOOL finished) {
            self.callout = stopView;
        }];
    }
}

- (void)removeCalloutView
{
    [self.callout removeFromSuperview];
    self.callout = nil;
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
