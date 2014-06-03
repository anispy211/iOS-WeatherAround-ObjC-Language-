//
//  AppDelegate.h
//  WeatherAround
//
//  Created by Aniruddha Kadam on 12/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)showProgressHUD:(NSString *)message forView:(UIView *)view;
-(void)hideProgressHUDForView:(UIView *)view;

@end
