//
//  CityModel.m
//  WeatherAround
//
//  Created by Aniruddha  on 27/01/14.
//  Copyright (c) 2014 @nispy. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

@synthesize cityName;
@synthesize countryName;
@synthesize date;
@synthesize wehtherDesc;
@synthesize wehtherIconName;
@synthesize idString;
@synthesize mainDictionary;
@synthesize windDictionary;
@synthesize currentTemp;

-(id)initwithDictionary:(NSDictionary *)data
{
   
    cityName = [data valueForKey:@"name"];
    NSDictionary * sysDict = [data valueForKey:@"sys"];
    
    countryName =  [sysDict valueForKey:@"country"];
    date =[[Utility sharedInstance] getDate:[[data valueForKey:@"dt"] doubleValue]];
    NSDictionary * weatherDict = [data valueForKey:@"weather"];
    wehtherDesc = [[weatherDict valueForKey:@"description"] lastObject];
    wehtherIconName = [[weatherDict valueForKey:@"icon"] lastObject] ;

    NSArray * idArr = [weatherDict valueForKey:@"id"];
    idString = [NSString stringWithFormat:@"%@",[idArr objectAtIndex:0]];
    mainDictionary = [data valueForKey:@"main"];
    windDictionary = [data valueForKey:@"wind"];
    currentTemp = [[Utility sharedInstance]  convertKelvinToCelcius:[[mainDictionary valueForKey:@"temp"] doubleValue]];
        
    return self;
}






@end
