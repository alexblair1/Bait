//
//  NavigationController.m
//  Bait
//
//  Created by Stephen Blair on 8/5/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0];
    self.navigationBar.translucent = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
