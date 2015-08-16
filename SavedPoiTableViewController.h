//
//  SavedPoiTableViewController.h
//  Bait
//
//  Created by Stephen Blair on 8/11/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

#import "SWRevealViewController.h"
#import "DataSource.h"
#import "AppDelegate.h"

@interface SavedPoiTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *fetchResultItems;

@end
