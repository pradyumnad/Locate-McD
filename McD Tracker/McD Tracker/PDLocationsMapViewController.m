//
//  PDLocationsMapViewController.m
//  LocationsMap
//
//  Created by Pradyumna Doddala on 25/12/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import "PDLocationsMapViewController.h"
#import "PDLocation.h"
#import "MapPoint.h"
#import <QuartzCore/QuartzCore.h>

static CGRect MapOriginalFrame;
static CGRect MapFullFrame;
static CGPoint MapCenter;

@interface PDLocationsMapViewController ()

@property (nonatomic, retain) NSMutableArray *locations;


- (void)showAnnotationsOnMapWithLocations:(NSArray *)aLocations;
- (MKCoordinateRegion)regionThatFitsAllLocations:(NSArray *)locations;

- (IBAction)tappedOnMapView;
- (void)detailDisclosureButtonTapped:(id)sender;
//Customisation
- (void)customizeViewWithShadow:(UIView *)view;
@end

@implementation PDLocationsMapViewController

@synthesize delegate = _delegate, dataSource = _dataSource, locations=_locations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id)delegate1 andDataSource:(id)dataSource1 {
    self = [super initWithNibName:@"PDLocationsMapViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate1;
        _dataSource = dataSource1;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    MapCenter = self.mapView.center;
    MapOriginalFrame = self.mapView.frame;
    CGSize size = [UIScreen mainScreen].bounds.size;
    MapFullFrame = CGRectMake(0, 0, size.width, size.height);
    
    self.closeButton.hidden = YES;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnMapView)];
    [self.tapGesture addTarget:self action:@selector(tappedOnMapView)];
    
    [self.mapView addGestureRecognizer:self.tapGesture];
    
    NSLog(@"%@ %@", [NSValue valueWithCGRect:MapOriginalFrame], [NSValue valueWithCGRect:MapFullFrame]);
    
    //User location tracking
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    
    _userLocation = [_locationManager.location copy];
    
    NSLog(@"%f %f User location", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    //DataSource
    _locations = [NSMutableArray new];
    if ([self.dataSource respondsToSelector:@selector(locationsForShowingInLocationsMap)]) {
        _locations = [[self.dataSource locationsForShowingInLocationsMap] mutableCopy];
        [self showAnnotationsOnMapWithLocations:self.locations];
    } else {
        NSLog(@"PDLocationsMapViewDataSource not set");
    }
//    [self customizeViewWithShadow:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.tapGesture = nil;
    self.mapView = nil;
}

#pragma mark -
#pragma mark Helpers

- (void)showAnnotationsOnMapWithLocations:(NSArray *)aLocations {
    for (PDLocation *location in aLocations) {
        MapPoint *mapPoint = [[MapPoint alloc] initWithCoordinate:location.location title:location.name subTitle:location.description];
        [self.mapView addAnnotation:mapPoint];
    }
    
    MKCoordinateRegion region = [self regionThatFitsAllLocations:self.locations];
    [self.mapView setRegion:region];
}

- (MKCoordinateRegion)regionThatFitsAllLocations:(NSArray *)locations1 {
    float Lat_Min = self.userLocation.coordinate.latitude, Lat_Max = self.userLocation.coordinate.latitude;
    float Long_Max = self.userLocation.coordinate.longitude, Long_Min = self.userLocation.coordinate.longitude;
    
    for (PDLocation *p in locations1) {
        if (Lat_Max > p.location.latitude) {
            Lat_Min = p.location.latitude;
        } else {
            Lat_Max = p.location.latitude;
        }
        
        if (Long_Max > p.location.longitude) {
            Long_Min = p.location.longitude;
        } else {
            Long_Max = p.location.longitude;
        }
        
        NSLog(@"%f %f", p.location.latitude, p.location.longitude);
    }
    NSLog(@">>> %f %f %f %f", Lat_Min, Lat_Max, Long_Min, Long_Max);
    
    CLLocationCoordinate2D min = CLLocationCoordinate2DMake(Lat_Min, Long_Min);
    
    CLLocationCoordinate2D max = CLLocationCoordinate2DMake(Lat_Max, Long_Max);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((max.latitude + min.latitude) / 2.0, (max.longitude + min.longitude) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(max.latitude - min.latitude, max.longitude - min.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    return region;
}

- (IBAction)tappedOnMapView {
//    NSLog(@"Tapped");
    [self.view bringSubviewToFront:self.mapView];
    
    if (CGRectEqualToRect(self.mapView.bounds, MapOriginalFrame)) {
        [UIView animateWithDuration:0.30 animations:^{
            self.mapView.frame = MapFullFrame;
        } completion:^(BOOL finished) {
            self.closeButton.hidden = NO;
            [self.view bringSubviewToFront:self.closeButton];
            [self.mapView removeGestureRecognizer:self.tapGesture];
//            NSLog(@"After done %@", [NSValue valueWithCGRect:self.mapView.bounds]);
        }];
    } else {
        [UIView animateWithDuration:0.30 animations:^{
            self.mapView.frame = MapOriginalFrame;
        } completion:^(BOOL finished) {
            self.closeButton.hidden = YES;
            [self.mapView addGestureRecognizer:self.tapGesture];
//            NSLog(@"After done %@", [NSValue valueWithCGRect:self.mapView.bounds]);
        }];
    }
}

#pragma mark -
#pragma mark CoreLocation
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    _userLocation = [newLocation copy];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark MapView

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
     
    static NSString* PDAnnotationIdentifier = @"PDAnnotationIdentifier";
    
    MKAnnotationView* pinView =
    (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:PDAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:PDAnnotationIdentifier];
        [pinView setImage:[UIImage imageNamed:@"mappin.png"]];
        pinView.canShowCallout = YES;
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [detailBtn addTarget:self action:@selector(detailDisclosureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = detailBtn;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    MapPoint *annotation = (MapPoint *)view.annotation;
    
    NSString* urlString = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma mark -
#pragma mark Actions

- (void)detailDisclosureButtonTapped:(id)sender {
    
}
#pragma mark - TableView Methods
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_locations count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.font = [UIFont fontWithName:@"Futura" size:15.0f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Futura" size:13.0f];
        
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 25.0)];
        distanceLabel.font = [UIFont fontWithName:@"Futura" size:12.0f];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor grayColor];
        distanceLabel.textAlignment = UITextAlignmentRight;
        cell.accessoryView = distanceLabel;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    id store = [self.locations objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectLocationAtIndex:)]) {
        [self.delegate didSelectLocationAtIndex:indexPath.row];
    } else {
        NSLog(@"PDLocationsMapViewDelegate not set");
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PDLocation *pdLocation = [_locations objectAtIndex:indexPath.row];
    NSAssert([pdLocation isKindOfClass:[PDLocation class]], @"DataSource must provide array of PDLocations");
    
    cell.textLabel.text = pdLocation.name;
    cell.detailTextLabel.text = pdLocation.description;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:pdLocation.location.latitude longitude:pdLocation.location.longitude];
    
    CLLocationDistance distance = [_userLocation distanceFromLocation:location];
    if (distance == 0) {
        
    } else {
        UILabel *distanceLabel = (UILabel *)cell.accessoryView;
        distanceLabel.text = [NSString stringWithFormat:@"%.01f Km", distance/1000];
    }
}

- (void)viewDidUnload {
    [self setTapGesture:nil];
    [self setCloseButton:nil];
    [super viewDidUnload];
}

//Customisation

- (void)customizeViewWithShadow:(UIView *)view {
    //white Border
    view.layer.borderWidth = 3.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //Shadow Effect for Profile Pic
    [view.layer setMasksToBounds:YES];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowOpacity:0.9];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(0, 3)];
    [view.layer setShouldRasterize:YES];
    
    CGSize size = view.bounds.size;
    CGFloat curlFactor = 13.0f;
    CGFloat shadowDepth = 8.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    view.layer.shadowPath = [path CGPath];
}
@end
