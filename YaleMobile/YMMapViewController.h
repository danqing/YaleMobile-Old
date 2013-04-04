//
//  YMMapViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YMMapDetailView.h"

@interface YMMapViewController : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet YMMapDetailView *detailView;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) UIView *searchOverlay;
@property (nonatomic, strong) UIButton *locate;
@property (nonatomic) NSInteger locating;

@end
