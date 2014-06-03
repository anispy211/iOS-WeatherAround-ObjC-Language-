//
//  WeatherNetworkRequest.h
//  WeatherAround
//
//  Created by Aniruddha Kadam on 5/27/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface WeatherNetworkRequest : NSURLRequest

@property (nonatomic,strong) CityModel * cityModel;
@property (nonatomic, readwrite) WeatherAPIRequestType weatherAPIType;

@end
