//
//  HoneyHoleTableViewController.h
//  Bait
//
//  Created by Stephen Blair on 8/15/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

#import "SWRevealViewController.h"
#import "DataSource.h"
#import "HoneyHole.h"

@interface HoneyHoleTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *fetchResultItems;

@end
