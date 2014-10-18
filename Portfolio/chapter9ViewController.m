//
//  chapter9ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 20/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter9ViewController.h"
#import "MyAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface chapter9ViewController () <CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic, strong) CLGeocoder *myGeocoder;
@end

@implementation chapter9ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    /* We received the new location */
    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
    
    /* We received the old location */
    NSLog(@"Old Latitude = %f", oldLocation.coordinate.latitude);
    NSLog(@"Old Longitude = %f", oldLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    /* Failed to receive user's location */
    NSLog(@"ERROR %@",error.description);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[MyAnnotation class]] == NO)
    {
        return result;
    }
    if ([mapView isEqual:self.myMapView] == NO)
    {
        /* We want to process this event only for the Map View
         that we have created previously */
        return result;
    
    }
    /* First typecast the annotation for which the Map View has
     fired this delegate message */
    MyAnnotation *senderAnnotation = (MyAnnotation *)annotation;

    /* Using the class method we have defined in our custom
     annotation class, we will attempt to get a reusable
     identifier for the pin we are about to create */
    NSString *pinReusableIdentifier = [MyAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];
    
    /* Using the identifier we retrieved above, we will
     attempt to reuse a pin in the sender Map View */
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView
     dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if (annotationView == nil)
    {
        NSLog(@"Failed to Reuse");
        /* If we fail to reuse a pin, then we will create one */
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation
                                                      reuseIdentifier:pinReusableIdentifier];
        /* Make sure we can see the callouts on top of
         each pin in case we have assigned title and/or
         subtitle to each pin */
        [annotationView setCanShowCallout:YES];
    }
    
//    /* Now make sure, whether we have reused a pin or not, that
//     the color of the pin matches the color of the annotation */
//    annotationView.pinColor = senderAnnotation.pinColor;
//    result = annotationView;
    
    UIImage *pinImage = [UIImage imageNamed:@"tab1"];
    if (pinImage != nil)
    {
        annotationView.image = pinImage;
    }
    result = annotationView;
    
    return result;
}

- (void) mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurants";
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    request.region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:
     ^(MKLocalSearchResponse *response, NSError *error)
    {
        for (MKMapItem *item in response.mapItems)
        {
            NSLog(@"Item name = %@", item.name);
            NSLog(@"Item phone number = %@", item.phoneNumber);
            NSLog(@"Item url = %@", item.url);
            NSLog(@"Item location = %@", item.placemark.location);
        }
    }];
}

- (void) mapView:(MKMapView *)mapView
didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Failed"
                              message:@"Could not get the user's location"
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //DIRECTIONS
    NSString *destination = @"Churchill Square Shopping Center, \
    Brighton, United Kingdom";
    [[CLGeocoder new]
     geocodeAddressString:destination
     completionHandler:^(NSArray *placemarks, NSError *error) {
         
         if (error != nil){
             /* Handle the error here perhaps by displaying an alert */ return;
         }
         MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
         request.source = [MKMapItem mapItemForCurrentLocation];
         
         /* Convert the CoreLocation destination
          placemark to a MapKit placemark */
         /* Get the placemark of the destination address */
         CLPlacemark *placemark = placemarks[0];
         CLLocationCoordinate2D destinationCoordinates =
         placemark.location.coordinate;
         MKPlacemark *destination = [[MKPlacemark alloc]
                                     initWithCoordinate:destinationCoordinates
                                     addressDictionary:nil];
         request.destination = [[MKMapItem alloc]
                                initWithPlacemark:destination];
         
         
         /* Set the transportation method to automobile */
         request.transportType = MKDirectionsTransportTypeAutomobile;
         
         /* Get the directions */
         MKDirections *directions = [[MKDirections alloc]
                                     initWithRequest:request];
         [directions calculateDirectionsWithCompletionHandler:
          ^(MKDirectionsResponse *response, NSError *error) {
              /* You can manually parse the response, but in here we will take
               a shortcut and use the Maps app to display our source and
               destination. We didn't have to make this API call at all,
               as we already had the map items before, but this is to
               demonstrate that the directions response contains more
               information than just the source and the destination. */
              /* Display the directions on the Maps app */
              [MKMapItem
               openMapsWithItems:@[response.source, response.destination]
               launchOptions:@{
                               MKLaunchOptionsDirectionsModeKey :
                                   MKLaunchOptionsDirectionsModeDriving}];
          }];
        }
     ];
    
    
    //TRACKING AND SEARCH
//    /* Create a map as big as our view */
//    self.myMapView = [[MKMapView alloc]
//                      initWithFrame:self.view.bounds];
//    self.myMapView.delegate = self; /* Set the map type to Standard */
//    self.myMapView.mapType = MKMapTypeStandard;
//    self.myMapView.autoresizingMask =
//    UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleHeight;
//    self.myMapView.showsUserLocation = YES;
//    self.myMapView.userTrackingMode = MKUserTrackingModeFollow;
//    /* Add it to our view */
//    [self.view addSubview:self.myMapView];



    //GEOCODING CLGeoCoder
//    /* We have our address */
//    NSString *oreillyAddress =
//    @"1005 Gravenstein Highway North, Sebastopol, CA 95472, USA";
//    
//    self.myGeocoder = [[CLGeocoder alloc] init];
//    [self.myGeocoder
//     geocodeAddressString:oreillyAddress
//     completionHandler:^(NSArray *placemarks, NSError *error)
//    {
//         if (placemarks.count > 0 && error == nil)
//         {
//             NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
//             CLPlacemark *firstPlacemark = placemarks[0];
//             NSLog(@"Longitude = %f",
//                   firstPlacemark.location.coordinate.longitude);
//             NSLog(@"Latitude = %f",
//                   firstPlacemark.location.coordinate.latitude);
//             
//             [self.myGeocoder
//              reverseGeocodeLocation:firstPlacemark.location
//              completionHandler:^(NSArray *placemarks, NSError *error)
//             {
//                  if (error == nil && placemarks.count > 0)
//                  {
//                      CLPlacemark *placemark = placemarks[0];
//                      /* We received the results */
//                      NSLog(@"Country = %@", placemark.country);
//                      NSLog(@"Postal Code = %@", placemark.postalCode);
//                      NSLog(@"Locality = %@", placemark.locality);
//                  }
//                  else if (error == nil && placemarks.count == 0){
//                      NSLog(@"No results were returned.");
//                  }
//                  else if (error != nil){
//                      NSLog(@"An error occurred = %@", error);
//                  }
//              }];
//         }
//         else if (placemarks.count == 0 &&
//                  error == nil)
//         {
//             NSLog(@"Found no placemarks.");
//         }
//         else if (error != nil)
//         {
//             NSLog(@"An error occurred = %@", error);
//         }
//     }];
    
    //CORE LOCATION
//    if ([CLLocationManager locationServicesEnabled])
//    {
//        self.myLocationManager = [[CLLocationManager alloc] init];
//        self.myLocationManager.delegate = self;
//        [self.myLocationManager startUpdatingLocation];
//    }
//    else
//    {
//            /* Location services are not enabled.
//             Take appropriate action: for instance, prompt the
//             user to enable the location services */
//            NSLog(@"Location services are not enabled");
//    }
    
    //LOAD MAP WITH ANNOTATION
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.myMapView = [[MKMapView alloc]
//                      initWithFrame:self.view.bounds];
//    /* Set the map type to Satellite */
//    self.myMapView.mapType = MKMapTypeStandard;
//    self.myMapView.delegate = self;
//    self.myMapView.autoresizingMask =
//    UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleHeight;
//    /* Add it to our view */
//    [self.view addSubview:self.myMapView];
//    
//    
//    /* This is just a sample location */
//    CLLocationCoordinate2D location =
//    CLLocationCoordinate2DMake(50.82191692907181, -0.13811767101287842);
//    /* Create the annotation using the location */
//    MyAnnotation *annotation =
//    [[MyAnnotation alloc] initWithCoordinates:location
//                                        title:@"My Title"
//                                     subTitle:@"My Sub Title"];
//    
//    annotation.pinColor = MKPinAnnotationColorPurple;
//    /* And eventually add it to the map */
//    [self.myMapView addAnnotation:annotation];
//    
//    [self.myMapView setCenterCoordinate:location];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
