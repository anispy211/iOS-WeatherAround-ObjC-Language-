//
//  WeatherAPIModel.m
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import "WeatherAPIModel.h"
#import "NetworkRequestModel.h"
#import "CityModel.h"

@interface WeatherAPIModel()
{
    NSMutableArray * cityRequestArray;
    
}

@property (nonatomic, strong) NSMutableDictionary *cityRefreshingInProgress;
@property (nonatomic, strong) NSMutableArray * responseCityArray;

@end

@implementation WeatherAPIModel

@synthesize delegate;




- (instancetype) initWithAPIKey:(NSString *) apiKey {
    self = [super init];
    if (self) {
        
        _baseURL = BASEURL;
        _apiKey  = apiKey;
        _apiVersion = APIVERSION;
        
    }
    return self;
}


#pragma mark - private parts

/**
 * Recursivly change temperatures in result data
 **/
- (NSDictionary *) convertResult:(NSDictionary *) res {
    
    NSMutableDictionary *dic = [res mutableCopy];
    
    NSMutableDictionary *main = [[dic objectForKey:@"main"] mutableCopy];
    if (main) {
        main[@"temp"] = [[Utility sharedInstance] convertTempToCelcius:main[@"temp"]];
        main[@"temp_min"] = [[Utility sharedInstance] convertTempToCelcius:main[@"temp_min"]];
        main[@"temp_max"] = [[Utility sharedInstance] convertTempToCelcius:main[@"temp_max"]];
        
        dic[@"main"] = [main copy];
        
    }
    
    NSMutableDictionary *temp = [[dic objectForKey:@"temp"] mutableCopy];
    if (temp) {
        temp[@"day"] = [[Utility sharedInstance] convertTempToCelcius:temp[@"day"]];
        temp[@"eve"] = [[Utility sharedInstance] convertTempToCelcius:temp[@"eve"]];
        temp[@"max"] = [[Utility sharedInstance] convertTempToCelcius:temp[@"max"]];
        temp[@"min"] = [[Utility sharedInstance] convertTempToCelcius:temp[@"min"]];
        temp[@"morn"] = [[Utility sharedInstance] convertTempToCelcius:temp[@"morn"]];
        temp[@"night"] = [[Utility sharedInstance] convertTempToCelcius:temp[@"night"]];
        
        dic[@"temp"] = [temp copy];
    }
    
    
    NSMutableDictionary *sys = [[dic objectForKey:@"sys"] mutableCopy];
    if (sys) {
        
        sys[@"sunrise"] = [[Utility sharedInstance] convertToDate: sys[@"sunrise"]];
        sys[@"sunset"] = [[Utility sharedInstance] convertToDate: sys[@"sunset"]];
        
        dic[@"sys"] = [sys copy];
    }
    
    
    NSMutableArray *list = [[dic objectForKey:@"list"] mutableCopy];
    if (list) {
        
        for (int i = 0; i < list.count; i++) {
            [list replaceObjectAtIndex:i withObject:[self convertResult: list[i]]];
        }
        
        dic[@"list"] = [list copy];
    }
    
    dic[@"dt"] = [[Utility sharedInstance] convertToDate:dic[@"dt"]];
    
    return [dic copy];
}


#pragma mark - public api

- (void) setApiVersion:(NSString *) version {
    _apiVersion = version;
}

- (NSString *) apiVersion {
    return _apiVersion;
}

- (void) setLangWithPreferedLanguage {
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // look up, lang and convert it to the format that openweathermap.org accepts.
    NSDictionary *langCodes = @{
                                @"sv" : @"se",
                                @"es" : @"sp",
                                @"en-GB": @"en",
                                @"uk" : @"ua",
                                @"pt-PT" : @"pt",
                                @"zh-Hans" : @"zh_cn",
                                @"zh-Hant" : @"zh_tw",
                                };
    
    NSString *l = [langCodes objectForKey:lang];
    if (l) {
        lang = l;
    }
    
    
    [self setLang:lang];
}

- (void) setLang:(NSString *) lang {
    _lang = lang;
}

- (NSString *) lang {
    return _lang;
}


/**
 * Calls the web api, and converts the result. Then it calls the callback on the caller-queue
 **/


- (void) addRequestForUrlString:(NSString *)urlString forRequestTyp:(WeatherAPIRequestType)requestType
{
    _newtworkRequestModel = [[NetworkRequestModel alloc] init];
    [_newtworkRequestModel setNetworkDelegate:self];
     NSString *url = [NSString stringWithFormat:@"%@%@%@&APPID=%@%@", _baseURL, _apiVersion, urlString, _apiKey, @"uk"];
    NSLog(@"-------- : %@",url);
    WeatherNetworkRequest *urlRequest = [WeatherNetworkRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setWeatherAPIType:requestType];
    [_newtworkRequestModel sendRequest:urlRequest];
    
    
    
}

#pragma mark  All City Current Weather


-(void) currentWeatherforCities:(NSArray *) cities
{
    NSArray * cityArray = [cities copy];
    
    if ([[Utility sharedInstance] isNetworkAvailable] == YES)
    {
        
        if (self.responseCityArray) {
            [self.responseCityArray removeAllObjects];
        }
        
        if (self.cityRefreshingInProgress) {
            [self.cityRefreshingInProgress removeAllObjects];
        }
        
        self.responseCityArray = [[NSMutableArray alloc] init];
        self.cityRefreshingInProgress = [[NSMutableDictionary alloc] init];
        for (CityModel * model in cityArray) {
          
            [self addRequestForCity:model];
        }
    }
}

- (void) addRequestForCity:(CityModel *)cityModel
{
    
    if (_newtworkRequestModel) {
      _newtworkRequestModel = nil;
    }
    
    _newtworkRequestModel = [[NetworkRequestModel alloc] init];
    [_newtworkRequestModel setNetworkDelegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"/weather?q=%@", [NSString stringWithFormat:@"%@",[cityModel.cityName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@&APPID=%@%@", _baseURL, _apiVersion, urlString, _apiKey, @"uk"];
    NSLog(@"-------- : %@",url);
    WeatherNetworkRequest * weatherRequest = [WeatherNetworkRequest requestWithURL:[NSURL URLWithString:url]];
    [weatherRequest setCityModel:cityModel];
    [weatherRequest setWeatherAPIType:kWeatherForCitiesByName];

    
    if ([self.cityRefreshingInProgress valueForKey:cityModel.idString] == nil)
    [self.cityRefreshingInProgress setObject:cityModel forKey:cityModel.idString];

    [_newtworkRequestModel sendRequest:weatherRequest];
    
}



#pragma mark Current Weather

-(void) currentWeatherByCityName:(NSString *) name
{
    NSString *urlString = [NSString stringWithFormat:@"/weather?q=%@", name];
    [self addRequestForUrlString:urlString forRequestTyp:kWeatherByCityName];
}

-(void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
{
    
    NSString *urlString = [NSString stringWithFormat:@"/weather?lat=%f&lon=%f",
                           coordinate.latitude, coordinate.longitude ];
    [self addRequestForUrlString:urlString forRequestTyp:kWeatherByCordinate];
    
}

-(void) currentWeatherByCityId:(NSString *) cityId
{
    NSString *urlString = [NSString stringWithFormat:@"/weather?id=%@", cityId];
    [self addRequestForUrlString:urlString forRequestTyp:kWeatherByCityId];
    
}


#pragma mark forcast

-(void) forecastWeatherByCityName:(NSString *) name
{
    
    NSString *urlString = [NSString stringWithFormat:@"/forecast?q=%@", name];
    [self addRequestForUrlString:urlString forRequestTyp:kForecastWeatherByCityName];
    
}

-(void) forecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
{
    
    NSString *urlString = [NSString stringWithFormat:@"/forecast?lat=%f&lon=%f",
                           coordinate.latitude, coordinate.longitude ];
    [self addRequestForUrlString:urlString forRequestTyp:kForecastWeatherByCordinate];

    
}

-(void) forecastWeatherByCityId:(NSString *) cityId
{
    NSString *urlString = [NSString stringWithFormat:@"/forecast?id=%@", cityId];
    [self addRequestForUrlString:urlString forRequestTyp:kForecastWeatherByCityId];

}

#pragma mark forcast - n days

-(void) dailyForecastWeatherByCityName:(NSString *) name
                             withCount:(int) count
{
    
    NSString *urlString = [NSString stringWithFormat:@"/forecast/daily?q=%@&cnt=%d", name, count];
    [self addRequestForUrlString:urlString forRequestTyp:kDailyForecastWeatherByCityName];

}

-(void) dailyForecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                               withCount:(int) count
{
    
    NSString *urlString = [NSString stringWithFormat:@"/forecast/daily?lat=%f&lon=%f&cnt=%d",
                           coordinate.latitude, coordinate.longitude, count ];
    [self addRequestForUrlString:urlString forRequestTyp:kDailyForecastWeatherByCordinate];
}

-(void) dailyForecastWeatherByCityId:(NSString *) cityId
                           withCount:(int) count
{
    NSString *urlString = [NSString stringWithFormat:@"/forecast?id=%@&cnt=%d", cityId, count];
    [self addRequestForUrlString:urlString forRequestTyp:kDailyForecastWeatherByCityId];

}


#pragma mark NetworkRequestModelDelegate

-(void)networkRequestDidCompleteWithData:(id)data forRequest:(WeatherNetworkRequest *)request
{
    
    switch (request.weatherAPIType) {
            
        case kWeatherForCitiesByName:
        {
          CityModel * cityModel =  [self parseCityWeatherData:data forRequest:request];
            
            [self.responseCityArray addObject:cityModel];
            
            // API BUG - need to handle in bad way
            [self.cityRefreshingInProgress  removeObjectForKey:cityModel.idString];

            if ([[self.cityRefreshingInProgress allKeys] count] == 0)
            {
                
            if (delegate && [delegate respondsToSelector:@selector(weatherAPIDidReturnValueForAllCities:)])
            [delegate weatherAPIDidReturnValueForAllCities:self.responseCityArray];
                
                return;
                    
            }
            
            
        }
            break;
        
        case kWeatherByCityName:
            [self parseCurrentWeatherWithData:data forRequest:request];
            break;
    
        case kWeatherByCordinate:
            [self parseCurrentWeatherWithData:data forRequest:request];
            break;
        
            
        case kDailyForecastWeatherByCityName :
            [self parseForecastWeatherWithData:data forRequest:request];
            break;
            
        case kDailyForecastWeatherByCordinate:
            [self parseForecastWeatherWithData:data forRequest:request];
            break;
            
        default:
            break;
    }
    
}

-(void)requestDidFailWithError:(NSString *)error
{
    NSLog(@"%@",error);
    
    if ([delegate respondsToSelector:@selector(weatherAPIDidReturnValuWithError:)]) {
        [delegate weatherAPIDidReturnValuWithError:error];
    }

}

#pragma mark Parsing method

- (CityModel *)parseCityWeatherData:(id)data forRequest:(WeatherNetworkRequest *)request
{
    
    id dict = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:NULL];
    
    
    
    if ([[dict valueForKey:COD] integerValue]==200)
    {
        
        CityModel *modal=[[CityModel alloc] initwithDictionary:dict];
        
        return modal;

    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(weatherAPIDidReturnValuWithError:)]) {
            [delegate weatherAPIDidReturnValuWithError:@"City Not Found"];
        }
    }
    
    
    return nil;
    
}




- (void)parseCurrentWeatherWithData:(id)data forRequest:(WeatherNetworkRequest *)request
{
    
    id dict = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:NULL];
    
    
    
    if ([[dict valueForKey:COD] integerValue]==200)
    {
        NSString * cityName =  [dict valueForKey:@"name"];
        
        if ([cityName isEqualToString:@""])   
        {
            
            
            if (delegate && [delegate respondsToSelector:@selector(weatherAPIDidReturnValuWithError:)]) {
                [delegate weatherAPIDidReturnValuWithError:INVALIDCITYMSG];
            }
            
            return;

        }
        
        
        CityModel *modal=[[CityModel alloc] initwithDictionary:dict];
        
        if (delegate && [delegate respondsToSelector:@selector(weatherAPIDidReturnValu:)]) {
            [delegate weatherAPIDidReturnValu:@[modal]];
        }
        
        
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(weatherAPIDidReturnValuWithError:)]) {
            [delegate weatherAPIDidReturnValuWithError:CITYNOTFOUND];
        }
    }
    



}


- (void)parseForecastWeatherWithData:(id)data forRequest:(WeatherNetworkRequest *)request
{
    id dict = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:NULL];
    
    NSData * jsondata = (NSData *)dict;
    
    if ([[dict valueForKey:COD] integerValue]==200)
    {
        
        NSString * cityName =  [dict valueForKey:@"name"];
        
        if ([cityName isEqualToString:@""])
        {
            
            
            if (delegate && [delegate respondsToSelector:@selector(weatherAPIDidReturnValuWithError:)]) {
                [delegate weatherAPIDidReturnValuWithError:INVALIDCITYMSG];
            }
            
            return;
        }


        
        NSMutableArray * dataArray = [[NSMutableArray alloc] init];
        NSDictionary *cityInfo=[jsondata valueForKey:@"city"];
        NSString * countryName=[cityInfo valueForKey:@"country"];
        NSArray *listArr =[jsondata valueForKey:@"list"];
        for (NSMutableDictionary *dict in listArr) {
            
            WetherInfoDataModal *modal=[[WetherInfoDataModal alloc]initwithDictionary:dict];
            modal.cityName = cityName;
            modal.countryName = countryName;
            [dataArray addObject:modal];
        }
        
        if ([delegate respondsToSelector:@selector(weatherAPIDidReturnValu:)]) {
            [delegate weatherAPIDidReturnValu:dataArray];
        }
    }
    else
    {
        if ([delegate respondsToSelector:@selector(weatherAPIDidReturnValuWithError:)]) {
            [delegate weatherAPIDidReturnValuWithError:CITYNOTFOUND];
        }
    }

}




@end
