//
//  DataSource.h
//  Bait
//
//  Created by Stephen Blair on 8/4/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataSource : NSObject

+(instancetype) sharedInstance;

@property (nonatomic, strong) CLLocationManager *locationManagerDS;
@property (nonatomic, strong) NSArray *mapItems;

-(void)localSearchRequestWithText:(NSString *)text withRegion:(MKCoordinateRegion)region completion:(void (^)(void))completionBlock;
@end
