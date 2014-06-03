//
//  CityModel.h
//  WeatherAround
//
//  Created by Aniruddha  on 27/01/14.
//  Copyright (c) 2014 @nispy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CityModel : NSObject

@property (nonatomic,strong) NSString * cityName;
@property (nonatomic,strong) NSString * countryName;
@property (nonatomic,strong) NSString * date;
@property (nonatomic,strong) NSString * wehtherDesc;
@property (nonatomic,strong) NSString * wehtherIconName;
@property (nonatomic,strong) NSString * idString;
@property (nonatomic,strong) NSString * currentTemp;
@property (nonatomic,strong) NSDictionary * mainDictionary;
@property (nonatomic,strong) NSDictionary * windDictionary;


-(id)initwithDictionary:(NSDictionary *)data;



@end
