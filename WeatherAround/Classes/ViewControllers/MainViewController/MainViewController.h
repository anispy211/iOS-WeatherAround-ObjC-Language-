//
//  ViewController.h
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NetworkRequestModel.h"
#import "SVGeocoder.h"
#import "SVPlacemark.h"


@interface MainViewController : UITableViewController<CLLocationManagerDelegate>
{
    NSMutableArray * cities;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
}
@end
