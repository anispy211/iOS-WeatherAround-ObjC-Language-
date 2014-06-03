//
//  wetherInfoCell.m
//  WeatherInfo
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha Kadam. All rights reserved.
//

#import "WetherInfoCell.h"

@implementation WetherInfoCell
@synthesize  Datelbl;
@synthesize  cityNameLbl;
@synthesize  tempLbl;
@synthesize  iconImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
