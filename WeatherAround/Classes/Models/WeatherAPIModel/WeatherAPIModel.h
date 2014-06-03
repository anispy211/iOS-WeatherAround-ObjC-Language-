//
//  WeatherAPIModel.h
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequestModel.h"
#import <CoreLocation/CoreLocation.h>
#import "WetherInfoDataModal.h"
#import "WeatherNetworkRequest.h"





@protocol WeatherAPIModelDelegate <NSObject>

-(void)weatherAPIDidReturnValu:(NSArray *)dataArray ;
-(void)weatherAPIDidReturnValuWithError:(NSString *)error;

@optional

-(void)weatherAPIDidReturnValueForAllCities:(NSMutableArray *)cityArr ;


@end

@interface WeatherAPIModel : NSObject<NetworkRequestModelDelegate>
{
    NetworkRequestModel *_newtworkRequestModel;
    
    NSString *_baseURL;
    NSString *_apiKey;
    NSString *_apiVersion;
    NSString *_lang;

}

@property(nonatomic, unsafe_unretained) id<WeatherAPIModelDelegate> delegate;






- (instancetype) initWithAPIKey:(NSString *) apiKey;

- (void) setApiVersion:(NSString *) version;
- (NSString *) apiVersion;


- (void) setLangWithPreferedLanguage;
- (void) setLang:(NSString *) lang;
- (NSString *) lang;


#pragma mark - All cities current weather


-(void) currentWeatherforCities:(NSArray *) cities;


#pragma mark - current weather

 -(void) currentWeatherByCityName:(NSString *) name;


 -(void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate;

 -(void) currentWeatherByCityId:(NSString *) cityId;

#pragma mark - forecast

 -(void) forecastWeatherByCityName:(NSString *) name;

 -(void) forecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate;

 -(void) forecastWeatherByCityId:(NSString *) cityId;

#pragma mark forcast - n days

 -(void) dailyForecastWeatherByCityName:(NSString *) name
                             withCount:(int) count;

 -(void) dailyForecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                               withCount:(int) count;

 -(void) dailyForecastWeatherByCityId:(NSString *) cityId
                           withCount:(int) count;



@end
