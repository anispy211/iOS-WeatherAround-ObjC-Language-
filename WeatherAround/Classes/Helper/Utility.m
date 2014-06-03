//
//  Utility.m
//  WeatherAround
//
//  Created by Aniruddhaon 15/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import "Utility.h"
#include <CFNetwork/CFNetworkDefs.h>


@implementation Utility

static Utility * utility= nil;

+ (Utility *)sharedInstance
{
    if (!utility) {
        
        utility = [[Utility alloc] init];
    }
    
    return utility;
}

#pragma mark Helper Method

- (NSURL *)dataStoragePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:cachePath];
    return url;
}

- (NSNumber *) tempToCelcius:(NSNumber *) tempKelvin
{
    return @(tempKelvin.floatValue - 273.15);
}

- (NSNumber *) tempToFahrenheit:(NSNumber *) tempKelvin
{
    return @((tempKelvin.floatValue * 9/5) - 459.67);
}



- (NSDate *) convertToDate:(NSNumber *) num {
    return [NSDate dateWithTimeIntervalSince1970:num.intValue];
}

-(NSString*)getDate:(double)dt
{
    NSTimeInterval interval=dt;
    NSDate *dateValue = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    return([formatter stringFromDate:dateValue]);
    
}


- (NSNumber *) convertTempToCelcius:(NSNumber *) tempKelvin
{
    return @(tempKelvin.floatValue - 273.15);
}

- (NSNumber *) convertTempToFahrenheit:(NSNumber *) tempKelvin
{
    return @((tempKelvin.floatValue * 9/5) - 459.67);
}

- (NSString *)convertKelvinToCelcius:(double)temp
{
    double celcius =temp-273.15;
    return [NSString stringWithFormat:@"%.2f°",celcius];
}


#pragma mark - Network Check

- (BOOL)isNetworkAvailable
{
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.google.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
        NSLog (@"Connection is down");
        return NO;
    }
}

- (void)saveCurrentCityList
{
    
    if ([self.currentCityList count]>0)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.currentCityList forKey:@"cityList"];
        [userDefaults synchronize];
    }
 
}


- (void)loadCityList
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:@"cityList"];
    
    if (arr)
    {
        [self setCurrentCityList:(NSMutableArray *)arr];
    }
    else
        [self setCurrentCityList:nil];
}

@end
