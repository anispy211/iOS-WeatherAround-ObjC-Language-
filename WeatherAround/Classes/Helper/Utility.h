//
//  Utility.h
//  WeatherAround
//
//  Created by Aniruddhaon 15/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

@property (nonatomic,strong) NSMutableArray * currentCityList;

+ (Utility *)sharedInstance;
- (BOOL)isNetworkAvailable;

- (NSURL *)dataStoragePath;

- (void)saveCurrentCityList;
- (void)loadCityList;

- (NSNumber *) tempToCelcius:(NSNumber *) tempKelvin;
- (NSNumber *) tempToFahrenheit:(NSNumber *) tempKelvin;
- (NSDate *) convertToDate:(NSNumber *) num;
- (NSString*)getDate:(double)dt;
- (NSNumber *) convertTempToCelcius:(NSNumber *) tempKelvin;
- (NSNumber *) convertTempToFahrenheit:(NSNumber *) tempKelvin;
- (NSString *)convertKelvinToCelcius:(double)temp;

@end
