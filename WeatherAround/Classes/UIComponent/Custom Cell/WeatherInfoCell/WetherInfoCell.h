//
//  wetherInfoCell.h
//  WeatherInfo
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WetherInfoCell : UITableViewCell
{

}

@property(nonatomic,weak)IBOutlet UILabel *Datelbl;
@property(nonatomic,weak)IBOutlet UILabel *cityNameLbl;
@property(nonatomic,weak)IBOutlet UILabel *tempLbl;
@property(nonatomic,weak)IBOutlet UIImageView *iconImgView;
@property(nonatomic,weak)IBOutlet UILabel *dayLbl;
@property(nonatomic,weak)IBOutlet UILabel *minMaxTempLbl;



@end
