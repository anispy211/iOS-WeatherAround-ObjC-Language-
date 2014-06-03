//
//  LocationManager.h
//  WeatherAround
//
//  Created by Aniruddhaon 13/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SVGeocoder.h"
#import "SVPlacemark.h"


@protocol LocationManagerDelegate <NSObject>


- (void)locationManagerDidLocateCityName:(NSString *)cityName;
- (void)locationManagerDidUpdateToLocation:(CLLocation *)currentLocation;
- (void)locationManagerDidFailWithError:(NSError *)error;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, weak) id<LocationManagerDelegate> delegate;

- (void)startLocationUpdate;
- (void)stopLocationUpdate;


+ (LocationManager*)sharedSingleton;



@end
