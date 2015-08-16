//
//  HoneyHole.h
//  Bait
//
//  Created by Stephen Blair on 8/15/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HoneyHole : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * xCoordinate;
@property (nonatomic, retain) NSNumber * yCoordinate;

@end
