//
//  GearViewController.h
//  Bait
//
//  Created by Stephen Blair on 8/17/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface GearViewController : UIViewController <WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end
