//
//  MKMapItem+Category.m
//  Bait
//
//  Created by Stephen Blair on 8/12/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import "MKMapItem+Category.h"

static char distanceStringKey;

@implementation MKMapItem (Category)
@dynamic distanceString;

-(void)setDistanceString:(NSString *)distanceString{
    objc_setAssociatedObject(self, &distanceStringKey, distanceString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)distanceString{
    return objc_getAssociatedObject(self, &distanceStringKey);
}

@end
