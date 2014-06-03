//
//  WetherInfoDataModal.m
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//



#import "WetherInfoDataModal.h"

@implementation WetherInfoDataModal
@synthesize cityName,countryName,dayTemp,eveTemp,humidty,maxTemp,minTemp,morTemp,nightTemp,wehtherDate,wehtherDesc,weatherIcon,weatherIconImg;

-(id)initwithDictionary:(NSDictionary *)data
{
    wehtherDate=[[Utility sharedInstance] getDate:[[data valueForKey:@"dt"] doubleValue]];
    humidty=[NSString stringWithFormat:@"%d%%",[[data valueForKey:@"humidity"] integerValue]];
    
    NSDictionary *tempDict=[data valueForKey:@"temp"];
    dayTemp=[[Utility sharedInstance]  convertKelvinToCelcius:[[tempDict valueForKey:@"day"] doubleValue]];
    eveTemp=[[Utility sharedInstance]  convertKelvinToCelcius:[[tempDict valueForKey:@"eve"] doubleValue]];
    maxTemp=[[Utility sharedInstance]  convertKelvinToCelcius:[[tempDict valueForKey:@"max"] doubleValue]];
    minTemp=[[Utility sharedInstance]  convertKelvinToCelcius:[[tempDict valueForKey:@"min"] doubleValue]];
    morTemp=[[Utility sharedInstance]  convertKelvinToCelcius:[[tempDict valueForKey:@"morn"] doubleValue]];
    nightTemp=[[Utility sharedInstance]  convertKelvinToCelcius:[[tempDict valueForKey:@"night"] doubleValue]];
    
    NSArray *wehtherDescArr=[data valueForKey:@"weather"];
   
    NSDictionary *wehtherDescDict=[wehtherDescArr objectAtIndex:0];
    wehtherDesc=[wehtherDescDict valueForKey:@"description"];
    weatherIcon = [wehtherDescDict valueForKey:@"icon"];
    return self;
}


@end
