//
//  Defines.h
//  WeatherAround
//
//  Created by Aniruddha  on 24/01/14.
//  Copyright (c) 2014 @nispy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Utility.h"


typedef enum {
    kWeatherByCityName,
    kWeatherByCordinate,
    kWeatherByCityId,
    kForecastWeatherByCityName,
    kForecastWeatherByCordinate,
    kForecastWeatherByCityId,
    kDailyForecastWeatherByCityName,
    kDailyForecastWeatherByCordinate,
    kDailyForecastWeatherByCityId,
    kWeatherForCitiesByName
} WeatherAPIRequestType;



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define WAAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#define  APIKEY @"3a5d2b1adbc565f9a961d9e934f4d7a2"
#define BASEURL @"http://api.openweathermap.org/data/"
#define APIVERSION @"2.5"


// Model
#define   COD  @"cod"



#define   INVALIDCITYMSG  @"Entered name is not a city Name"
#define   CITYNOTFOUND  @"City Not Found"

