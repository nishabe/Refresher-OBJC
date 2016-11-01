//
//  MKMapViewViewController.m
//  Refresher-OBJC
//
//  Created by   on 10/31/16.
//  Copyright © 2016  Inc. All rights reserved.
// Ref: http://www.codeproject.com/Articles/869481/Using-MapKit-and-CoreLocation-Information-in-iOS
// https://www.appcoda.com/ios-programming-101-drop-a-pin-on-map-with-mapkit-api/


#import "MKMapViewViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define ORIGIN_X 10
#define ORIGIN_Y 20
#define TAB_BAR_HEIGHT 60

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

@interface MKMapViewViewController () <CLLocationManagerDelegate>
@property (nonatomic,strong)UILabel *latitude;
@property (nonatomic,strong)UILabel *longitude;
@property (nonatomic,strong)UILabel *altitude;
@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation MKMapViewViewController

#pragma mark View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureMapView];
    [self configureLocationManager];
    [self addInfoLabels];
}

#pragma mark Private Functions

- (void) configureLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    // we have to setup the location manager with permission in later iOS versions
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    // When you declare your locationManager make sure to set the sensitivity. Without this, the update is getting called constantly, which will center the screen all the time with mapview set region.
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}
- (void) configureMapView{
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.zoomEnabled = YES;
    [self.view addSubview:self.mapView];
}
- (void)addInfoLabels{
    self.latitude = [[UILabel alloc]initWithFrame:CGRectMake(ORIGIN_X,self.view.bounds.size.height - ORIGIN_Y * 4 - TAB_BAR_HEIGHT, 200, 40)];
    [[self view] addSubview:self.latitude];
    self.longitude = [[UILabel alloc]initWithFrame:CGRectMake(ORIGIN_X, self.view.bounds.size.height - ORIGIN_Y *2.5 - TAB_BAR_HEIGHT, 200, 40)];
    [[self view] addSubview:self.longitude];
    self.altitude = [[UILabel alloc]initWithFrame:CGRectMake(ORIGIN_X, self.view.bounds.size.height - ORIGIN_Y - TAB_BAR_HEIGHT, 200, 40)];
    [[self view] addSubview:self.altitude];
}

#pragma mark CLLocatin Manager Delegate Handling

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = locations.lastObject;
    
    // zoom the map into the users current location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance
    (location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
    [[self mapView] setRegion:viewRegion animated:YES];
    
    // Update the labels
    [self.latitude setText:[NSString stringWithFormat:@"%@:%.6f",@"LAT",
                                   location.coordinate.latitude]];
    [self.longitude setText:[NSString stringWithFormat:@"%@:%.6f",@"LONG",
                                    location.coordinate.longitude]];
    [self.altitude setText:[NSString stringWithFormat:@"%@:%.2f feet",@"ALT",
                                   location.altitude*METERS_FEET]];
    // Add an annotation
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D cordinates= CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    annotationPoint.coordinate = cordinates;
    annotationPoint.title = @"Where am I?";
    annotationPoint.subtitle = @"I'm here!!!";
    [self.mapView addAnnotation:annotationPoint];
}

@end
