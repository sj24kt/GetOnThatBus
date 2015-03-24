//
//  RootViewController.m
//  GetOnThatBus
//
//  Created by Sherrie Jones on 3/24/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>

@interface RootViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *busStopAnnotation;
@property CLLocationManager *locationManager;
@property NSDictionary *feedDictionary;
@property NSMutableArray *feedArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.feedDictionary = [NSDictionary new];
    self.feedArray = [NSMutableArray new];


    double latitude = 41.8781136;
    double longitude = -87.6297982;
    self.busStopAnnotation = [MKPointAnnotation new];
    self.busStopAnnotation = [MKPointAnnotation new];
    self.busStopAnnotation.title = @"Chicago Downtown";
    self.busStopAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView addAnnotation:self.busStopAnnotation];

    [self geoCodeLocation:@"Chicago, IL"];
    [self displayUserLocation];
}

// sets the pin - runs for each annotation view
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if (![annotation isEqual:mapView.userLocation]) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        //pin.image = [UIImage imageNamed:@"makersImage"];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pin;
    } else {
        return nil;
    }
}

- (void)geoCodeLocation:(NSString *)addressString {

    NSString *address = addressString;
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = place.location.coordinate;
            annotation.title = place.name;
            [self.mapView addAnnotation:annotation];
            //NSLog(@"%@", annotation.description);

        }
    }];
}

- (void)displayUserLocation {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;

}





@end












