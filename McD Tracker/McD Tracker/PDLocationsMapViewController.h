//
//  PDLocationsMapViewController.h
//  LocationsMap
//
//  Created by Pradyumna Doddala on 25/12/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol PDLocationsMapDelegate <NSObject>

- (void)didSelectLocationAtIndex:(int)index;
@end

@protocol PDLocationsMapDataSource <NSObject>

- (NSArray *)locationsForShowingInLocationsMap;
@end

@interface PDLocationsMapViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    __unsafe_unretained id <PDLocationsMapDataSource>dataSource;
    __unsafe_unretained id <PDLocationsMapDelegate>delegate;
}

@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *userLocation;

@property (nonatomic, assign) __unsafe_unretained id <PDLocationsMapDataSource>dataSource;
@property (nonatomic, assign) __unsafe_unretained id <PDLocationsMapDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;

- (id)initWithDelegate:(id)delegate andDataSource:(id)dataSource;
@end
