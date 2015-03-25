//
//  RootViewController.m
//  GetOnThatBus
//
//  Created by Sherrie Jones on 3/24/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>

@interface RootViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *busStopsArray;
@property NSDictionary *selectedDictionary;
@property MKPointAnnotation *paceAnnotation;
@property MKPointAnnotation *metraAnnotation;
@property MKPointAnnotation *noTransferAnnotation;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedDictionary = [[NSDictionary alloc]init];

    [self requestAPI];

}

#pragma mark - Helper methods

// Accesses and deserializes API
- (void)requestAPI {

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        self.busStopsArray = [jsonDictionary objectForKey:@"row"];

        [self getBusStopsData];

        // Zooms map to Chicago area
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.84, -87.70);
        MKCoordinateSpan span = MKCoordinateSpanMake(.3, .3);
        MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
        [self.mapView setRegion:region];

    }];
}

// Enumerates through each bus-stop's data in API
- (void)getBusStopsData {

    for (NSDictionary *busDictionary in self.busStopsArray) {

        // Retrieves necessary data from API for each bus stop
        NSString *latitude = [busDictionary objectForKey:@"latitude"];
        NSString *longitude = [busDictionary objectForKey:@"longitude"];
        double latConvertedToDouble = [latitude doubleValue];
        double longConvertedToDouble = [longitude doubleValue];

        // Adds the appropriate custom class (which subclass PointAnnotationView) depending on the bus-stops transfer option
        NSString *transferMode = [busDictionary objectForKey:@"inter_modal"];

        if ([transferMode isEqualToString:@"Pace"]) {

            self.paceAnnotation = [MKPointAnnotation new];
            self.paceAnnotation.coordinate = CLLocationCoordinate2DMake(latConvertedToDouble, longConvertedToDouble);
            self.paceAnnotation.title = [busDictionary objectForKey:@"cta_stop_name"];
            self.paceAnnotation.subtitle = [busDictionary objectForKey:@"routes"];
            [self.mapView addAnnotation:self.paceAnnotation];

        }
        else if ([transferMode isEqualToString:@"inter_modal"]) {

            self.metraAnnotation = [MKPointAnnotation new];
            self.metraAnnotation.coordinate = CLLocationCoordinate2DMake(latConvertedToDouble, longConvertedToDouble);
            self.metraAnnotation.title = [busDictionary objectForKey:@"cta_stop_name"];
            self.metraAnnotation.subtitle = [busDictionary objectForKey:@"routes"];
            [self.mapView addAnnotation:self.metraAnnotation];

        } else {

            self.noTransferAnnotation = [[MKPointAnnotation alloc]init];
            self.noTransferAnnotation.coordinate = CLLocationCoordinate2DMake(latConvertedToDouble, longConvertedToDouble);
            self.noTransferAnnotation.title = [busDictionary objectForKey:@"cta_stop_name"];
            self.noTransferAnnotation.subtitle = [busDictionary objectForKey:@"routes"];
            [self.mapView addAnnotation:self.noTransferAnnotation];

        }
    }
}

@end




















