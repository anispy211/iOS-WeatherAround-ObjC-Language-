//
//  WetherInfoDataModal.h
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface WetherInfoDataModal : NSObject

@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *countryName;
@property(nonatomic,strong)NSString *wehtherDate;
@property(nonatomic,strong)NSString *wehtherDesc;
@property(nonatomic,strong)NSString *humidty;
@property(nonatomic,strong)NSString *dayTemp;
@property(nonatomic,strong)NSString *minTemp;
@property(nonatomic,strong)NSString *maxTemp;
@property(nonatomic,strong)NSString *nightTemp;
@property(nonatomic,strong)NSString *eveTemp;
@property(nonatomic,strong)NSString *morTemp;
@property(nonatomic,strong)NSString *weatherIcon;
@property(nonatomic,strong)UIImage *weatherIconImg;


-(id)initwithDictionary:(NSDictionary *)data;
@end
