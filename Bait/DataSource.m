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

-(void)saveSelectedRegionWithName:(NSString *)name withDistance:(NSString *)distance withY:(float)yCoordinate withX:(float)xCoordinate{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:context];
    NSManagedObject *newRegion = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    [newRegion setValue:name forKey:@"name"];
    [newRegion setValue:[NSNumber numberWithFloat:yCoordinate] forKey:@"yCoordinate"];
    [newRegion setValue:[NSNumber numberWithFloat:xCoordinate] forKey:@"xCoordinate"];
    [newRegion setValue:distance forKey:@"distance"];
    
    NSError *error = nil;
    
    if (![newRegion.managedObjectContext save:&error]) {
        NSLog(@"unable to save managed context");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

-(void)fetchRequest{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Region"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"name" cacheName:nil];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"unable to perform fetch");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    self.fetchResultItems = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
    NSLog(@"fetch result items: %@", self.fetchResultItems);
}

@end
