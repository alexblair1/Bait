//
//  DataSource.m
//  Bait
//
//  Created by Stephen Blair on 8/4/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+(instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id) init{
    self = [super init];
    if (self) {
        self.locationManagerDS = [[CLLocationManager alloc] init];
    }
    return self;
}

#pragma mark - Data handling for MapTableViewController/SavedPoiTableViewController

-(void)localSearchRequestWithText:(NSString *)text withRegion:(MKCoordinateRegion)region completion:(void (^)(void))completionBlock{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = text;
    request.region = region;
    
    MKLocalSearch *localSearchRequest = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearchRequest startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"no matches found");
        } else {
            self.mapItems = response.mapItems;
            NSLog(@"%@", response.mapItems);
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

-(void)saveSelectedRegionWithName:(NSString *)name withDistance:(NSString *)distance withY:(float)yCoordinate withX:(float)xCoordinate withAddress:(NSString *)address{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:context];
    NSManagedObject *newRegion = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    [newRegion setValue:name forKey:@"name"];
    [newRegion setValue:[NSNumber numberWithFloat:yCoordinate] forKey:@"yCoordinate"];
    [newRegion setValue:[NSNumber numberWithFloat:xCoordinate] forKey:@"xCoordinate"];
    [newRegion setValue:distance forKey:@"distance"];
    [newRegion setValue:address forKey:@"address"];
    
    NSError *error = nil;
    
    if (![newRegion.managedObjectContext save:&error]) {
        NSLog(@"unable to save managed context");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark - Data Handling for HoneyHoleTableViewController 

-(void)saveHoneyHoleWithName:(NSString *)name withY:(float)yCoordinate withX:(float)xCoordinate{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HoneyHole" inManagedObjectContext:context];
    NSManagedObject *newRegion = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    [newRegion setValue:name forKey:@"name"];
    [newRegion setValue:[NSNumber numberWithFloat:yCoordinate] forKey:@"yCoordinate"];
    [newRegion setValue:[NSNumber numberWithFloat:xCoordinate] forKey:@"xCoordinate"];
    
    NSError *error = nil;
    
    if (![newRegion.managedObjectContext save:&error]) {
        NSLog(@"unable to save managed context");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

@end
