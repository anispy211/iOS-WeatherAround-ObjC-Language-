//
//  NetworkRequestModel.h
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//





#import <Foundation/Foundation.h>
#import "WeatherNetworkRequest.h"

@protocol NetworkRequestModelDelegate <NSObject>

-(void)networkRequestDidCompleteWithData:(id)data forRequest:(WeatherNetworkRequest *)request;
-(void)requestDidFailWithError:(NSString *)error;

@end



@interface NetworkRequestModel : NSObject

@property(nonatomic, unsafe_unretained) id<NetworkRequestModelDelegate> networkDelegate;

-(void)sendRequest:(WeatherNetworkRequest *)request;

@end
