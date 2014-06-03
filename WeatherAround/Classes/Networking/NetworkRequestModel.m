//
//  NetworkRequestModel.m
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//




#import "NetworkRequestModel.h"

@interface NetworkRequestModel()
{
    NSMutableData *_data;
}
@end

@implementation NetworkRequestModel
@synthesize networkDelegate;


- (instancetype) init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


-(void)sendRequest:(WeatherNetworkRequest *)request
{

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
         
             if ([networkDelegate respondsToSelector:@selector(networkRequestDidCompleteWithData:forRequest:)])
             {
                 [networkDelegate  networkRequestDidCompleteWithData:data forRequest:request];
             }
             
         }
         else
         {
             if ([networkDelegate respondsToSelector:@selector(requestDidFailWithError:)])
             [networkDelegate requestDidFailWithError:connectionError.localizedDescription];
         }
         
     }];

}


//-(void)succesfullyParseData:(id)data forRequest:(NSURLRequest *)request
//{
//    if ([[data valueForKey:@"cod"] integerValue]==200) {
//        
//        if ([networkDelegate respondsToSelector:@selector(networkRequestDidCompleteWithData:forRequest:)])
//        {
//            [networkDelegate  networkRequestDidCompleteWithData:data forRequest:request];
//        }
//    }
//    else
//    {
//        if ([networkDelegate respondsToSelector:@selector(requestDidFailWithError:)])
//        [networkDelegate requestDidFailWithError:@"City Not Found"];
//    }
//}



@end
