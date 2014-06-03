//
//  LocationManager.m
//  WeatherAround
//
//  Created by Aniruddhaon 13/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager


@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       //do any more customization to your location manager
    }
    
    return self;
}

+ (LocationManager*)sharedSingleton {
    static LocationManager* sharedSingleton;
    if(!sharedSingleton) {
            sharedSingleton = [LocationManager new];
    }
    
    return sharedSingleton;
}


- (void)startLocationUpdate
{
[ self.locationManager startUpdatingLocation];
}

- (void)stopLocationUpdate
{
    [ self.locationManager stopUpdatingLocation];
}

#pragma mark CLLocation Manager Delgate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    if ([_delegate respondsToSelector:@selector(locationManagerDidFailWithError:)]) {
        [_delegate locationManagerDidFailWithError:error];
    }

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    CLLocation *currentLocation = newLocation;
    
    
    
    CLGeocoder *clGeocoder = [[CLGeocoder alloc]init];
    [clGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placeMark = [placemarks lastObject];
        
        
        for(CLPlacemark *placemark in placemarks){
            NSLog(@"location //// %@",[placemark location]);
            NSLog(@"locality  %@",[placemark locality]); }
        
        CLLocation *loc = [placeMark location];
        
        CLLocationCoordinate2D cor2D = [loc coordinate];
        
        
        [SVGeocoder reverseGeocode:cor2D completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
            if([placemarks count] > 6){
                [locationManager stopUpdatingLocation];
                NSDictionary *addDict = [placemarks objectAtIndex:5];
                NSString *address = [addDict valueForKey:@"formattedAddress"];
                NSArray *arr = [address componentsSeparatedByString:@","];
                NSString *city = [arr objectAtIndex:0];
                NSLog(@"The City is : %@ ", city);
                
                if (city) {
                    
                    
                    
                    if([_delegate respondsToSelector:@selector(locationManagerDidUpdateToLocation:)])
                    {
                        [_delegate locationManagerDidLocateCityName:city];
                        [self.locationManager stopUpdatingLocation];
                    }
                    
                    
                    
                }
                
                if ([arr objectAtIndex:0] != nil) {
                    
                }
                
            }
            
            
        }];
    }];
    
    [locationManager stopUpdatingLocation];

    
}




        


@end
