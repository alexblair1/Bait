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


@end
