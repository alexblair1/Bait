//
//  MapTableViewController.h
//  Bait
//
//  Created by Stephen Blair on 8/4/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

#import "DataSource.h"
#import "MapTableViewCell.h"
#import "SWRevealViewController.h"
#import "MKMapItem+Category.h"


@interface MapTableViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *subtitle2;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPointAnnotation *pointAnnotation;
@property (nonatomic) MKCoordinateRegion *region;
@property (nonatomic, strong) NSMutableArray *storedMapItemsForTableView;

@end
