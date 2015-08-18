//
//  MapTableViewController.m
//  Bait
//
//  Created by Stephen Blair on 8/4/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import "MapTableViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"


@interface MapTableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@property (nonatomic, strong) NSMutableDictionary *distancesDictionary;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) MKCoordinateRegion regionSearch;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MKMapItem *itemForRouteAndAlertView;
@property (nonatomic, strong) NSArray *mapItems;


@end

@implementation MapTableViewController

- (void)viewDidLoad {
    //TODO: map view is not loading with correct region. Region needs to be set to 30-40 miles.
    [super viewDidLoad];
    [self performSelectorOnMainThread:@selector(initializeMapViewAndLocationManager) withObject:nil waitUntilDone:NO];
    [self initializeNavigationImage];
    [self initializeTableView];
    [self initializeRevealView];

//    uncomment for parse error test
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [NSException raise:NSGenericException format:@"Everything is ok. This is just a test crash."];
//    });
}

#pragma mark - Initialization methods

-(void) initializeTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void) initializeRevealView{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void) initializeMapViewAndLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.mapView setZoomEnabled:YES];
    
    CLLocationCoordinate2D startCoord;
    startCoord.latitude = self.locationManager.location.coordinate.latitude;
    startCoord.longitude = self.locationManager.location.coordinate.longitude;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(startCoord, 70000, 70000);
    
    [self.mapView setRegion:region animated:YES];
}

-(void) initializeNavigationImage{
    UIImage *fishHookImage = [UIImage imageNamed:@"baitText.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:fishHookImage];
    self.navigationItem.titleView = imageView;
}

#pragma mark - Location Manager

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){
        
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager startUpdatingLocation];
            self.mapView.showsUserLocation = YES;
        }
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
//    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSString *searchString = NSLocalizedString(@"fishing", "local search text");
    
    [[DataSource sharedInstance] localSearchRequestWithText:searchString withRegion:self.mapView.region completion:^{
        
        for (MKMapItem *items in [DataSource sharedInstance].mapItems){
            self.pointAnnotation = [[MKPointAnnotation alloc] init];
            self.pointAnnotation.coordinate = items.placemark.coordinate;
            self.pointAnnotation.title = items.name;
            [self.mapView addAnnotation:self.pointAnnotation];
            
            CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:items.placemark.coordinate.latitude longitude:items.placemark.coordinate.longitude];
            
            self.distance = 0.000621371192 * [location distanceFromLocation:userLocation];
            NSLog(@"distance in miles: %.2f", self.distance);
            
            items.distanceString = [NSString stringWithFormat:@"%.2f", self.distance];
            NSLog(@"TEST FROM MONKEY PATCH: %@", items.distanceString);
            
            self.storedMapItemsForTableView = [NSMutableArray arrayWithArray:[DataSource sharedInstance].mapItems];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distanceString" ascending:YES];
        [self.storedMapItemsForTableView sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        NSLog(@"!!!!!!!!!: %@", self.storedMapItemsForTableView);
        
        [self.tableView reloadData];
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Annotations

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //custom annotation view
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:self.pointAnnotation reuseIdentifier:@"detailViewController"];
    
    customPinView.pinColor = MKPinAnnotationColorRed;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    return customPinView;
}

#pragma mark - Table View Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[DataSource sharedInstance].mapItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LocalResultsCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocalResultsCell"];
    }
    
    //cell styling
    MKMapItem *item = self.storedMapItemsForTableView [indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Miles", item.distanceString];
//    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];

    cell.textLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0];
    
//    [self.tableView setSeparatorColor:[UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0]];
    cell.imageView.image = [UIImage imageNamed:@"fishHook.png"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.itemForRouteAndAlertView = self.storedMapItemsForTableView [indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Would you like to route to: %@", self.itemForRouteAndAlertView.name];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    float y = self.itemForRouteAndAlertView.placemark.location.coordinate.latitude;
    float x = self.itemForRouteAndAlertView.placemark.location.coordinate.longitude;
    
    if (buttonIndex == 1)
    {
        [[DataSource sharedInstance] saveSelectedRegionWithName:self.itemForRouteAndAlertView.name withDistance:self.itemForRouteAndAlertView.distanceString withY:y withX:x withAddress:self.itemForRouteAndAlertView.placemark.addressDictionary[@"Street"]];
        
        NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
        [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
        [self.itemForRouteAndAlertView openInMapsWithLaunchOptions:launchOptions];
    }
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
