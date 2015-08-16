//
//  DataSource.h
//  Bait
//
//  Created by Stephen Blair on 8/4/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "MapTableViewController.h"


@interface DataSource : NSObject <NSFetchedResultsControllerDelegate>

+(instancetype) sharedInstance;

@property (nonatomic, strong) CLLocationManager *locationManagerDS;
@property (nonatomic, strong) NSArray *mapItems;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *fetchResultItems;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; 

-(void)localSearchRequestWithText:(NSString *)text withRegion:(MKCoordinateRegion)region completion:(void (^)(void))completionBlock;
-(void)saveSelectedRegionWithName:(NSString *)name withDistance:(NSString *)distance withY:(float)yCoordinate withX:(float)xCoordinate withAddress:(NSString *)address;
-(void)saveHoneyHoleWithName:(NSString *)name withY:(float)yCoordinate withX:(float)xCoordinate;

@end
